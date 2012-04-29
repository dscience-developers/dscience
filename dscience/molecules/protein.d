/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

/**
 * Protein definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/molecules/protein.d
 */
module dscience.molecules.protein;

import std.string;

import dscience.physic.molecule;
import dscience.physic.bond;
import dscience.physic.atom;
import Math = std.math;

interface IProtein{
    public:
        @property:
            IMolecule[]     doPeptideBond();
            string          name();
            size_t          numberOfStranded();
            size_t          numberOfMolecules();
            IMolecule[][]   strands();
}

class Protein : IProtein{
    private:
        string          _name;
        IMolecule[][]   _strands;

    public:
        this(string name, IMolecule[][] strands){
            _name       = name;
            _strands  = strands;
        }

        IMolecule[] getMolecules(size_t strandNum){
            return _strands[strandNum];
        }

        @property:
            string name(){
                return name.idup;
            }

            size_t numberOfStranded(){
                return _strands.length;
            }

            size_t numberOfMolecules(){ // TODO see std.algorithm.reduce
                size_t counter = 0;
                foreach(molecules; _strands)
                    counter += molecules.length;
                return counter;
            }

            IMolecule[] doPeptideBond(){
                IMolecule[] waters      = new IMolecule[](numberOfMolecules - 2);
                size_t      waterIndex  = 0;
                foreach(strand; _strands){
                    size_t index = 0;
                    while(index+1 < strand.length){
                        //TODO
                        IMolecule   molecule1       = strand[index];
                        IMolecule   molecule2       = strand[++index];
                        ICompound[] carboxyls       = molecule1.compounds("carboxylic acid");
                        ICompound[] amines          = molecule2.compounds("primary amine", "secondary amine");
                        double      min             = 99;
                        size_t      carboxylIndex   = 0;
                        size_t      amineIndex      = 0;
                        bool        bondExist       = false;
                        foreach(i,carboxyl; carboxyls){
                            IAtom[] carbons = carboxyl.find("C");
                            foreach(j,amine; amines){
                                IAtom[] nitrogens = amine.find("N");
                                double distance = Math.sqrt(Math.pow(cast(real)(carbons[0].x - nitrogens[0].x), 2u) + Math.pow(cast(real)(carbons[0].y - nitrogens[0].y), 2u) + Math.pow(cast(real)(carbons[0].z - nitrogens[0].z), 2u));
                                if(min > distance){
                                    min             = distance;
                                    carboxylIndex   = i;
                                    amineIndex      = j;
                                    bondExist = (carbons[0].isLinkWith (nitrogens[0].atomId ) != -1); // No or yes, peptide bond CO-NH
                                }

                            }
                        }
                        // Now we know with which atom do the peptide bonds carboxyls[carboxylIndex] amines[amineIndex]
                        // if bond do not exist
                        if(!bondExist){
                            IAtom[] hydrogens1  = carboxyls[carboxylIndex].find("H");
                            IAtom[] oxygens     = carboxyls[carboxylIndex].find("O");
                            IAtom[] hydrogens2  = amines[amineIndex].find("H");
                            IAtom   oxygen      = null;
                            bool    isSearching = true;
                            size_t  i           = 0;
                            while(isSearching){
                                if(oxygens[i].isLinkWith( hydrogens1[0].atomId ) != -1){
                                    oxygen = oxygens[i];
                                    isSearching = false;
                                }
                                i++;
                            }
                            molecule1.remove(oxygen, hydrogens1[0]);
                            molecule2.remove(hydrogens2[0]);
                            bondFactory("covalent",oxygen, hydrogens1[0]);
                            bondFactory("covalent",oxygen, hydrogens2[0]);
                            IMolecule water     = new Molecule([oxygen, hydrogens1[0], hydrogens2[0]], "water");
                            waters[waterIndex]  = water;
                            waterIndex++;
                        }
                    }
                }
                waters.length = waterIndex;
                return waters;
            }

            IMolecule[][] strands(){
                return _strands;
            }

}
