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
 * Amino acid definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/molecules/amino_acid.d
 */
module dscience.molecules.amino_acid;

import std.string;

import dscience.physic.molecule;
import dscience.physic.bond;
import dscience.physic.atom;
import dscience.exception;

interface IAmino : IMolecule, ISymbol{
    public:

        /**
         * get x , y and z from atom
         */
        double[] getAtomLocation(IAtom atom);

        /**
         * set x , y and z from atom
         */
         void setAtomLocation(IAtom atom, double x, double y, double z);

        /**
         * Add an Atom to molecule
         */
        void addAtom(IAtom atom, IBond bond);

         /**
         * return compound list
         */
        ref ICompound[] compounds(string type);

        /**
         * return compound list
         */
        ref ICompound[] compounds(string[] types...);

        /**
         * return compound
         */
        ICompound compound(size_t compoundId);

        /**
         * Returns:
         * number of max electron could have in last level from atom
         */
        size_t maxElectronInLastLevel(IAtom atom);

        /**
         *  remove atom from molecule
         */
        void remove(IAtom[] atom ...);

        @property:

            /**
             * Returns:
             * bond array
             */
            IBond[] bonds();

            /**
             * return polar or nonpolar
             */
            string      chainPolarity();

            /**
             * Returns:
             * compounds array
             */
            ref ICompound[] compoundsList();

            /**
             * return mean electronegativity
             */
            float       electronegativity();

            /**
             * return hydropathy index
             */
            float       hydropathyIndex();

            /**
             * return 1 letter
             */
            char        letter();

            /**
             * return 3 letters
             */
            string      letters();

            /**
             * get x mean, y mean and z mean from molecule
             */
            double[]    location();

}

class Amino : IAmino{
    private:
        IMolecule   _molecule;
        string      _letters;
        char        _letter;
        string      _chainPolarity;
        float       _hydropathyIndex;

    public:
        this(IAtom[] atoms, string name, string letters, char letter, string chainPolarity, float hydropathyIndex){
            _molecule       = new Molecule(atoms, name);
            _letters        = letters;
            _letter         = letter;
            _chainPolarity  = chainPolarity;
            _hydropathyIndex= hydropathyIndex;
        }

        this(IAtom[] atoms, ICompound[] compounds, string name, string letters, char letter, string chainPolarity, float hydropathyIndex){
            _molecule       = new Molecule(atoms, compounds, name);
            _letters        = letters;
            _letter         = letter;
            _chainPolarity  = chainPolarity;
            _hydropathyIndex= hydropathyIndex;
        }

        /**
         * set x , y and z from atom
         */
         void setAtomLocation(IAtom atom, double x, double y, double z){
            _molecule.setAtomLocation(atom, x, y, z);
         }

         /**
         * set x , y and z from atom
         */
         void setAtomLocation(string type, size_t atomNum, double x, double y, double z){
            _molecule.setAtomLocation(type, atomNum, x, y, z);
         }

        /**
         * return atom list
         */
        IAtom[] findAtoms(string type){
            return _molecule.findAtoms(type);
        }

        /**
         * get x , y and z from atom
         */
        double[] getAtomLocation(IAtom atom){
            return _molecule.getAtomLocation(atom);
        }

        /**
         * Add an Atom to molecule
         */
        void addAtom(IAtom atom, IBond bond){
            _molecule.addAtom(atom, bond);
        }

         /**
         * return compound list
         */
        ref ICompound[] compounds(string type){
            return _molecule.compounds(type);
        }

        /**
         * return compound list
         */
        ref ICompound[] compounds(string[] types...){
            return _molecule.compounds(types);
        }

        /**
         * return compound
         */
        ICompound compound(size_t compoundId){
            return _molecule.compound(compoundId);
        }

        /**
         * Returns:
         * number of max electron could have in last level from atom
         */
        size_t maxElectronInLastLevel(IAtom atom){
            return _molecule.maxElectronInLastLevel(atom);
        }

        /**
         *  remove atom from molecule
         */
        void remove(IAtom[] atom...){
            _molecule.remove(atom);
        }

        @property:

            /**
             * Returns:
             * atoms array
             */
            ref IAtom[] atoms(){
                return _molecule.atoms;
            }

            /**
             * Returns:
             * bond array
             */
            IBond[] bonds(){
                return _molecule.bonds;
            }

            /**
             * return polar or nonpolar
             */
            string chainPolarity(){
                return _chainPolarity.idup;
            }

            /**
             * Returns:
             * compounds array
             */
            ref ICompound[] compoundsList(){
                return _molecule.compoundsList();
            }

            /**
             * return mean electronegativity
             */
            float electronegativity(){
                return _molecule.electronegativity();
            }

            /**
             * return hydropathy index
             */
            float hydropathyIndex(){
                return _hydropathyIndex;
            }

            /**
             * return 1 letter
             */
            char letter(){
                return _letter;
            }

            /**
             * return 3 letters
             */
            string letters(){
                return _letters.idup;
            }

            /**
             * get x mean, y mean and z mean from molecule
             */
            double[] location(){
                return _molecule.location();
            }

            /**
             * return molecule name
             */
            string name(){
                return _molecule.name;
            }

}


Amino aminoFactory(string aminoName){
    Amino amino = null;
    switch(aminoName){
        case "alanine":
        case "Alanine":
        case "ala":
        case "Ala":
        case "A":
            //Molecular formula     C3H7NO2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent", c1, h1);
            IBond           b2      = bondFactory("covalent", c1, h2);
            IBond           b3      = bondFactory("covalent", c1, h3);
            IBond           b4      = bondFactory("covalent", c1, c2);
            IBond           b5      = bondFactory("covalent", c2, n1);
            IBond           b6      = bondFactory("covalent", n1, h4);
            IBond           b7      = bondFactory("covalent", n1, h5);
            IBond           b8      = bondFactory("covalent", c2, c3);
            IBond           b9      = bondFactory("covalent", c3, o1);
            IBond           b10     = bondFactory("covalent",4u, c3, o2);
            IBond           b11     = bondFactory("covalent", o2, h6);
            ICompound       amine   = compoundFactory("primary amine", [n1,h4,h5]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c3,o1,o2,h6]);
            amino = new Amino([c1,c2,c3,h1,h2,h3,h4,h5,h6,h7,n1,o1,o2], [amine, carbo], "Alanine", "Ala", 'A', "nonpolar", 1.8f);
            break;

        case "arginine":
        case "Arginine":
        case "arg":
        case "Arg":
        case "R":
            //Molecular formula     C6H14N4O2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           h12     = atomFactory("H");
            IAtom           h13     = atomFactory("H");
            IAtom           h14     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           n2      = atomFactory("N");
            IAtom           n3      = atomFactory("N");
            IAtom           n4      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent", n1, h1);
            IBond           b2      = bondFactory("covalent", n1, h2);
            IBond           b3      = bondFactory("covalent", n1, c1);
            IBond           b4      = bondFactory("covalent", 4u, c1, n2);
            IBond           b5      = bondFactory("covalent", n2, h3);
            IBond           b6      = bondFactory("covalent", c1, n3);
            IBond           b7      = bondFactory("covalent", n3, h4);
            IBond           b8      = bondFactory("covalent", n3, c2);
            IBond           b9      = bondFactory("covalent", c2, h5);
            IBond           b10     = bondFactory("covalent", c2, h6);
            IBond           b11     = bondFactory("covalent", c2, c3);
            IBond           b12     = bondFactory("covalent", c3, h7);
            IBond           b13     = bondFactory("covalent", c3, h8);
            IBond           b14     = bondFactory("covalent", c3, c4);
            IBond           b15     = bondFactory("covalent", c4, h9);
            IBond           b16     = bondFactory("covalent", c4, h10);
            IBond           b17     = bondFactory("covalent", c4, c5);
            IBond           b18     = bondFactory("covalent", c5, h11);
            IBond           b19     = bondFactory("covalent", c5, n4);
            IBond           b20     = bondFactory("covalent", n4, h12);
            IBond           b21     = bondFactory("covalent", n4, h13);
            IBond           b22     = bondFactory("covalent", c5, c6);
            IBond           b23     = bondFactory("covalent", 4u, c6, o2);
            IBond           b24     = bondFactory("covalent", c6, o1);
            IBond           b25     = bondFactory("covalent", o1, h14);
            ICompound       amine1  = compoundFactory("primary amine", [n1,h1,h2]);
            ICompound       amine2  = compoundFactory("primary amine", [n4,h12,h13]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c6,o1,o2,h14]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,n1,n2,n3,n4,o1,o2], [amine1, amine2, carbo], "Arginine", "Arg", 'R', "polar", -4.5f);
            break;

        case "Asparagine":
        case "asparagine":
        case "asn":
        case "Asn":
        case "N":
            //Molecular formula     C4H8N2O3
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           n2      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",4u, c1, o1);
            IBond           b2      = bondFactory("covalent", c1, n1);
            IBond           b3      = bondFactory("covalent", n1, h1);
            IBond           b4      = bondFactory("covalent", n1, h2);
            IBond           b5      = bondFactory("covalent", c1, c2);
            IBond           b6      = bondFactory("covalent", c2, h3);
            IBond           b7      = bondFactory("covalent", c2, h4);
            IBond           b8      = bondFactory("covalent", c2, c3);
            IBond           b9      = bondFactory("covalent", c3, h5);
            IBond           b10     = bondFactory("covalent", c3, n2);
            IBond           b11     = bondFactory("covalent", n2, h6);
            IBond           b12     = bondFactory("covalent", n2, h7);
            IBond           b13     = bondFactory("covalent", c3, c4);
            IBond           b14     = bondFactory("covalent",4u, c4, o2);
            IBond           b15     = bondFactory("covalent", c4, o3);
            IBond           b16     = bondFactory("covalent", o3, h8);
            ICompound       amine1  = compoundFactory("primary amine", [n1,h1,h2]);
            ICompound       amine2  = compoundFactory("primary amine", [n2,h6,h7]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c4,o2,o3,h8]);
            amino = new Amino([c1,c2,c3,c4,h1,h2,h3,h4,h5,h6,h7,h8,n1,n2,o1,o2,o3], [amine1, amine2, carbo], "Asparagine", "Asn", 'N', "polar", 3.5f);
            break;

        case "Aspartic acid":
        case "aspartic acid":
        case "asp":
        case "Asp":
        case "D":
            //Molecular formula     C4H7NO4
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IAtom           o4      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",4u, c1, o1);
            IBond           b2      = bondFactory("covalent", c1, o2);
            IBond           b3      = bondFactory("covalent", o2, h1);
            IBond           b4      = bondFactory("covalent", c1, c2);
            IBond           b5      = bondFactory("covalent", c2, h2);
            IBond           b6      = bondFactory("covalent", c2, h3);
            IBond           b7      = bondFactory("covalent", c2, c3);
            IBond           b8      = bondFactory("covalent", c3, h4);
            IBond           b9      = bondFactory("covalent", c3, n1);
            IBond           b10     = bondFactory("covalent", n1, h5);
            IBond           b11     = bondFactory("covalent", n1, h6);
            IBond           b12     = bondFactory("covalent", c3, c4);
            IBond           b13     = bondFactory("covalent",4u,c4, o3);
            IBond           b14     = bondFactory("covalent", c4, o4);
            IBond           b15     = bondFactory("covalent", o4, h7);
            ICompound       amine   = compoundFactory("primary amine", [n1,h5,h6]);
            ICompound       carbo1  = compoundFactory("carboxylic acid", [c1,o1,o2,h1]);
            ICompound       carbo2  = compoundFactory("carboxylic acid", [c4,o3,o4,h7]);
            amino = new Amino([c1,c2,c3,c4,h1,h2,h3,h4,h5,h6,h7,n1,o1,o2,o3,o4], [amine, carbo1, carbo2],"Aspartic acid", "Asp", 'D', "polar", -3.5f);
            break;

        case "Cysteine":
        case "cysteine":
        case "cys":
        case "Cys":
        case "C":
            //Molecular formula     C3H7NO2S
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           s1      = atomFactory("S");
            IBond           b1      = bondFactory("covalent", c1, n1);
            IBond           b2      = bondFactory("covalent", n1, h1);
            IBond           b3      = bondFactory("covalent", n1, h2);
            IBond           b4      = bondFactory("covalent", c1, h3);
            IBond           b5      = bondFactory("covalent", c1, c2);
            IBond           b6      = bondFactory("covalent", c2, h4);
            IBond           b7      = bondFactory("covalent", c2, h5);
            IBond           b8      = bondFactory("covalent", c2, s1);
            IBond           b9      = bondFactory("covalent", s1, h6);
            IBond           b10     = bondFactory("covalent", c1, c3);
            IBond           b11     = bondFactory("covalent", 4u, c3, o1);
            IBond           b12     = bondFactory("covalent", c3, o2);
            IBond           b13     = bondFactory("covalent", o2, h7);
            ICompound       amine   = compoundFactory("primary amine", [n1,h1,h2]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c3,o1,o2,h7]);
            ICompound       thiol   = compoundFactory("thiol", [s1,h6]);
            amino = new Amino([c1,c2,c3,h1,h2,h3,h4,h5,h6,h7,n1,o1,o2,s1], [amine, carbo, thiol], "Cysteine", "Cys", 'C', "nonpolar", 2.5f);
            break;

        case "Glutamic acid":
        case "glutamic acid":
        case "glu":
        case "Glu":
        case "E":
            //Molecular formula     C5H9NO4
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IAtom           o4      = atomFactory("O");
            IBond           b1      = bondFactory("covalent", c1, o1);
            IBond           b2      = bondFactory("covalent", o1, h1);
            IBond           b3      = bondFactory("covalent",4u,c1, o2);
            IBond           b4      = bondFactory("covalent", c1, c2);
            IBond           b5      = bondFactory("covalent", c2, h2);
            IBond           b6      = bondFactory("covalent", c2, h3);
            IBond           b7      = bondFactory("covalent", c2, c3);
            IBond           b8      = bondFactory("covalent", c3, h4);
            IBond           b9      = bondFactory("covalent", c3, h5);
            IBond           b10     = bondFactory("covalent", c3, c4);
            IBond           b11     = bondFactory("covalent", c4, h6);
            IBond           b12     = bondFactory("covalent", c4, n1);
            IBond           b13     = bondFactory("covalent", n1, h7);
            IBond           b14     = bondFactory("covalent", n1, h8);
            IBond           b15     = bondFactory("covalent", c4, c5);
            IBond           b16     = bondFactory("covalent", c5, o3);
            IBond           b17     = bondFactory("covalent", o3, h9);
            IBond           b18     = bondFactory("covalent",4u, c5, o4);
            ICompound       amine   = compoundFactory("primary amine", [n1,h1,h2]);
            ICompound       carbo1  = compoundFactory("carboxylic acid", [c1,o1,o2,h1]);
            ICompound       carbo2  = compoundFactory("carboxylic acid", [c5,o3,o4,h9]);
            amino = new Amino([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,h6,h7,h8,h9,n1,o1,o2,o3,o4], [amine, carbo1, carbo2], "Glutamic acid", "Glu", 'E', "polar", -3.5f);
            break;

        case "Glutamine":
        case "glutamine":
        case "gln":
        case "Gln":
        case "Q":
            //Molecular formula     C5H10N2O3
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           n2      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IBond           b1      = bondFactory("covalent", c1, n1);
            IBond           b2      = bondFactory("covalent", n1, h1);
            IBond           b3      = bondFactory("covalent", n1, h2);
            IBond           b4      = bondFactory("covalent",4u, c1, o1);
            IBond           b5      = bondFactory("covalent",c1, c2);
            IBond           b6      = bondFactory("covalent",c2, h3);
            IBond           b7      = bondFactory("covalent",c2, h4);
            IBond           b8      = bondFactory("covalent",c2, c3);
            IBond           b9      = bondFactory("covalent",c3, h5);
            IBond           b10     = bondFactory("covalent",c3, h6);
            IBond           b11     = bondFactory("covalent",c3, c4);
            IBond           b12     = bondFactory("covalent",c4, h7);
            IBond           b13     = bondFactory("covalent",c4, n2);
            IBond           b14     = bondFactory("covalent",n2, h8);
            IBond           b15     = bondFactory("covalent",n2, h9);
            IBond           b16     = bondFactory("covalent",c4, c5);
            IBond           b17     = bondFactory("covalent",4u,c5, o2);
            IBond           b18     = bondFactory("covalent",c5, o3);
            IBond           b19     = bondFactory("covalent",o3, h10);
            ICompound       amine1  = compoundFactory("primary amine", [n1,h1,h2]);
            ICompound       amine2  = compoundFactory("primary amine", [n2,h8,h9]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c5,o2,o3,h10]);
            amino = new Amino([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,n1,n2,o1,o2,o3], [amine1, amine2, carbo], "Glutamine", "Gln", 'Q', "polar", 3.5f);
            break;

        case "Glycine":
        case "glycine":
        case "gly":
        case "Gly":
        case "G":
            //Molecular formula     C2H5NO2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, n1);
            IBond           b2      = bondFactory("covalent",n1, h1);
            IBond           b3      = bondFactory("covalent",n1, h2);
            IBond           b4      = bondFactory("covalent",c1, h3);
            IBond           b5      = bondFactory("covalent",c1, h4);
            IBond           b6      = bondFactory("covalent",c1, c2);
            IBond           b7      = bondFactory("covalent",c2, o1);
            IBond           b8      = bondFactory("covalent",o1, h5);
            IBond           b9      = bondFactory("covalent",4u,c2, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h1,h2]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c2,o1,o2,h5]);
            amino = new Amino([c1,c2,h1,h2,h3,h4,h5,n1,o1,o2],[amine, carbo], "Glycine", "Gly", 'G', "nonpolar", -0.4f);
            break;

        case "Histidine":
        case "histidine":
        case "his":
        case "His":
        case "H":
            //Molecular formula     C6H9N3O2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           n2      = atomFactory("N");
            IAtom           n3      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, n1);
            IBond           b3      = bondFactory("covalent",n1, h2);
            IBond           b4      = bondFactory("covalent",n1, c2);
            IBond           b5      = bondFactory("covalent",c2, h3);
            IBond           b6      = bondFactory("covalent",4u,c2, n2);
            IBond           b7      = bondFactory("covalent",n2, c3);
            IBond           b8      = bondFactory("covalent",4u,c3, c1);
            IBond           b9      = bondFactory("covalent",c3, c4);
            IBond           b10     = bondFactory("covalent",c4, h4);
            IBond           b11     = bondFactory("covalent",c4, h5);
            IBond           b12     = bondFactory("covalent",c4, c5);
            IBond           b13     = bondFactory("covalent",c5, h6);
            IBond           b14     = bondFactory("covalent",c5, n3);
            IBond           b15     = bondFactory("covalent",n3, h7);
            IBond           b16     = bondFactory("covalent",n3, h8);
            IBond           b17     = bondFactory("covalent",c5, c6);
            IBond           b18     = bondFactory("covalent",c6, o1);
            IBond           b19     = bondFactory("covalent",o1, h9);
            IBond           b20     = bondFactory("covalent",4u,c6, o2);
            ICompound       amine   = compoundFactory("primary amine", [n3,h7,h8]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c6,o1,o2,h9]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,h1,h2,h3,h4,h5,h6,h7,h8,h9,n1,n2,n3,o1,o2], [amine, carbo], "Histidine", "His", 'H', "polar", -3.2f);
            break;

        case "Isoleucine":
        case "isoleucine":
        case "ile":
        case "Ile":
        case "I":
            //Molecular formula     C6H13NO2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           h12     = atomFactory("H");
            IAtom           h13     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, h3);
            IBond           b4      = bondFactory("covalent",c1, c2);
            IBond           b5      = bondFactory("covalent",c2, h4);
            IBond           b6      = bondFactory("covalent",c2, h5);
            IBond           b7      = bondFactory("covalent",c2, c3);
            IBond           b8      = bondFactory("covalent",c3, h6);
            IBond           b9      = bondFactory("covalent",c3, c4);
            IBond           b10     = bondFactory("covalent",c4, h7);
            IBond           b11     = bondFactory("covalent",c4, h8);
            IBond           b12     = bondFactory("covalent",c4, h9);
            IBond           b13     = bondFactory("covalent",c3, c5);
            IBond           b14     = bondFactory("covalent",c5, h10);
            IBond           b15     = bondFactory("covalent",c5, n1);
            IBond           b16     = bondFactory("covalent",n1, h11);
            IBond           b17     = bondFactory("covalent",n1, h12);
            IBond           b18     = bondFactory("covalent",c5, c6);
            IBond           b19     = bondFactory("covalent",c6, o1);
            IBond           b20     = bondFactory("covalent",o1, h13);
            IBond           b21     = bondFactory("covalent",4u,c6, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h11,h12]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c6,o1,o2,h13]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,n1,o1,o2], [amine, carbo], "Isoleucine", "Ile", 'I', "nonpolar", 4.5f);
            break;

        case "Leucine":
        case "leucine":
        case "leu":
        case "Leu":
        case "L":
            //Molecular formula     C6H13NO2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           h12     = atomFactory("H");
            IAtom           h13     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, h3);
            IBond           b4      = bondFactory("covalent",c1, c2);
            IBond           b5      = bondFactory("covalent",c2, h4);
            IBond           b6      = bondFactory("covalent",c2, c3);
            IBond           b7      = bondFactory("covalent",c3, h5);
            IBond           b8      = bondFactory("covalent",c3, h6);
            IBond           b9      = bondFactory("covalent",c3, h7);
            IBond           b10     = bondFactory("covalent",c2, c4);
            IBond           b11     = bondFactory("covalent",c4, h8);
            IBond           b12     = bondFactory("covalent",c4, h9);
            IBond           b13     = bondFactory("covalent",c4, c5);
            IBond           b14     = bondFactory("covalent",c5, h10);
            IBond           b15     = bondFactory("covalent",c5, n1);
            IBond           b16     = bondFactory("covalent",n1, h11);
            IBond           b17     = bondFactory("covalent",n1, h12);
            IBond           b18     = bondFactory("covalent",c5, c6);
            IBond           b19     = bondFactory("covalent",c6, o1);
            IBond           b20     = bondFactory("covalent",o1, h13);
            IBond           b21     = bondFactory("covalent",4u,c6, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h11,h12]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c6,o1,o2,h13]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,n1,o1,o2], [amine, carbo], "Leucine", "Leu", 'L', "nonpolar", 3.8f);
            break;

        case "Lysine":
        case "lysine":
        case "lys":
        case "Lys":
        case "K":
            //Molecular formula     C6H14N2O2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           h12     = atomFactory("H");
            IAtom           h13     = atomFactory("H");
            IAtom           h14     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           n2      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, n1);
            IBond           b4      = bondFactory("covalent",n1, h3);
            IBond           b5      = bondFactory("covalent",n1, h4);
            IBond           b6      = bondFactory("covalent",c1, c2);
            IBond           b7      = bondFactory("covalent",c2, h5);
            IBond           b8      = bondFactory("covalent",c2, h6);
            IBond           b9      = bondFactory("covalent",c2, c3);
            IBond           b10     = bondFactory("covalent",c3, h7);
            IBond           b11     = bondFactory("covalent",c3, h8);
            IBond           b12     = bondFactory("covalent",c3, c4);
            IBond           b13     = bondFactory("covalent",c4, h9);
            IBond           b14     = bondFactory("covalent",c4, h10);
            IBond           b15     = bondFactory("covalent",c4, c5);
            IBond           b16     = bondFactory("covalent",c5, h11);
            IBond           b17     = bondFactory("covalent",c5, n2);
            IBond           b18     = bondFactory("covalent",n2, h12);
            IBond           b19     = bondFactory("covalent",n2, h13);
            IBond           b20     = bondFactory("covalent",c5, c6);
            IBond           b21     = bondFactory("covalent",c6, o1);
            IBond           b22     = bondFactory("covalent",o1, h14);
            IBond           b23     = bondFactory("covalent",4u,c6, o2);
            ICompound       amine1  = compoundFactory("primary amine", [n1,h2,h4]);
            ICompound       amine2  = compoundFactory("primary amine", [n2,h12,h13]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c6,o1,o2,h14]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,n1,n2,o1,o2], [amine1, amine2, carbo], "Lysine", "Lys", 'K', "polar", -3.9f);
            break;

        case "Methionine":
        case "methionine":
        case "met":
        case "Met":
        case "M":
            //Molecular formula     C5H11NO2S
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           s1      = atomFactory("S");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, h3);
            IBond           b4      = bondFactory("covalent",c1, s1);
            IBond           b5      = bondFactory("covalent",s1, c2);
            IBond           b6      = bondFactory("covalent",c2, h4);
            IBond           b7      = bondFactory("covalent",c2, h5);
            IBond           b8      = bondFactory("covalent",c2, c3);
            IBond           b9      = bondFactory("covalent",c3, h6);
            IBond           b10     = bondFactory("covalent",c3, h7);
            IBond           b11     = bondFactory("covalent",c3, c4);
            IBond           b12     = bondFactory("covalent",c4, h8);
            IBond           b13     = bondFactory("covalent",c4, n1);
            IBond           b14     = bondFactory("covalent",n1, h9);
            IBond           b15     = bondFactory("covalent",n1, h10);
            IBond           b16     = bondFactory("covalent",c4, c5);
            IBond           b17     = bondFactory("covalent",c5, o1);
            IBond           b18     = bondFactory("covalent",o1, h11);
            IBond           b19     = bondFactory("covalent",4u,c5, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h9,h10]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c5,o1,o2,h11]);
            amino = new Amino([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,n1,o1,o2,s1], [amine, carbo], "Methionine", "Met", 'M', "nonpolar", 1.9f);
            break;

        case "Phenylalanine":
        case "phenylalanine":
        case "phe":
        case "Phe":
        case "F":
            //Molecular formula     C9H11NO2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           c7      = atomFactory("C");
            IAtom           c8      = atomFactory("C");
            IAtom           c9      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, c2);
            IBond           b2      = bondFactory("covalent",c2, h1);
            IBond           b3      = bondFactory("covalent",4u,c2, c3);
            IBond           b4      = bondFactory("covalent",c3, h2);
            IBond           b5      = bondFactory("covalent",c3, c4);
            IBond           b6      = bondFactory("covalent",c4, h3);
            IBond           b7      = bondFactory("covalent",4u,c4, c5);
            IBond           b8      = bondFactory("covalent",c5, h4);
            IBond           b9      = bondFactory("covalent",c5, c6);
            IBond           b10     = bondFactory("covalent",c6, h5);
            IBond           b11     = bondFactory("covalent",4u,c6, c1);
            IBond           b12     = bondFactory("covalent",c1, c7);
            IBond           b13     = bondFactory("covalent",c7, h6);
            IBond           b14     = bondFactory("covalent",c7, h7);
            IBond           b15     = bondFactory("covalent",c7, c8);
            IBond           b16     = bondFactory("covalent",c8, h8);
            IBond           b17     = bondFactory("covalent",c8, n1);
            IBond           b18     = bondFactory("covalent",n1, h9);
            IBond           b19     = bondFactory("covalent",n1, h10);
            IBond           b20     = bondFactory("covalent",c8, c9);
            IBond           b21     = bondFactory("covalent",c9, o1);
            IBond           b22     = bondFactory("covalent",o1, h11);
            IBond           b23     = bondFactory("covalent",4u,c9, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h9,h10]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c9,o1,o2,h11]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,c7,c8,c9,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,n1,o1,o2], [amine, carbo], "Phenylalanine", "Phe", 'F', "nonpolar", 2.8f);
            break;

        case "Proline":
        case "proline":
        case "pro":
        case "Pro":
        case "P":
            //Molecular formula     C5H9NO2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, n1);
            IBond           b3      = bondFactory("covalent",n1, h2);
            IBond           b4      = bondFactory("covalent",n1, c2);
            IBond           b5      = bondFactory("covalent",c2, h3);
            IBond           b6      = bondFactory("covalent",c2, h4);
            IBond           b7      = bondFactory("covalent",c2, c3);
            IBond           b8      = bondFactory("covalent",c3, h5);
            IBond           b9      = bondFactory("covalent",c3, h6);
            IBond           b10     = bondFactory("covalent",c3, c4);
            IBond           b11     = bondFactory("covalent",c4, h7);
            IBond           b12     = bondFactory("covalent",c4, h8);
            IBond           b13     = bondFactory("covalent",c4, c1);
            IBond           b14     = bondFactory("covalent",c1, c5);
            IBond           b15     = bondFactory("covalent",c5, o1);
            IBond           b16     = bondFactory("covalent",o1, h9);
            IBond           b17     = bondFactory("covalent",4u,c5, o2);
            ICompound       amine   = compoundFactory("secondary amine", [n1,h2]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c5,o1,o2,h9]);
            amino = new Amino([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,h6,h7,h8,h9,n1,o1,o2], [amine, carbo], "Proline", "Pro", 'P', "nonpolar", -1.6f);
            break;

        case "Serine":
        case "serine":
        case "ser":
        case "Ser":
        case "S":
            //Molecular formula         C3H7NO3
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, o1);
            IBond           b4      = bondFactory("covalent",o1, h3);
            IBond           b5      = bondFactory("covalent",c1, c2);
            IBond           b6      = bondFactory("covalent",c2, h4);
            IBond           b7      = bondFactory("covalent",c2, n1);
            IBond           b8      = bondFactory("covalent",n1, h5);
            IBond           b9      = bondFactory("covalent",n1, h6);
            IBond           b10     = bondFactory("covalent",c2, c3);
            IBond           b11     = bondFactory("covalent",c3, o1);
            IBond           b12     = bondFactory("covalent",o1, h7);
            IBond           b13     = bondFactory("covalent",4u, c3, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h5,h6]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c3,o1,o2,h7]);
            amino = new Amino([c1,c2,c3,h1,h2,h3,h4,h5,h6,h7,n1,o1,o2,o3], [amine, carbo], "Serine", "Ser", 'S', "polar", -0.8f);
            break;

        case "Threonine":
        case "threonine":
        case "Thr":
        case "thr":
        case "T":
            //Molecular formula     C4H9NO3
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, h3);
            IBond           b4      = bondFactory("covalent",c1, c2);
            IBond           b5      = bondFactory("covalent",c2, h4);
            IBond           b6      = bondFactory("covalent",c2, o1);
            IBond           b7      = bondFactory("covalent",o1, h5);
            IBond           b8      = bondFactory("covalent",c2, c3);
            IBond           b9      = bondFactory("covalent",c3, h6);
            IBond           b10     = bondFactory("covalent",c3, n1);
            IBond           b11     = bondFactory("covalent",n1, h7);
            IBond           b12     = bondFactory("covalent",n1, h8);
            IBond           b13     = bondFactory("covalent",c3, c4);
            IBond           b14     = bondFactory("covalent",c4, o1);
            IBond           b15     = bondFactory("covalent",o1, h9);
            IBond           b16     = bondFactory("covalent",4u, c4, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h7,h8]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c4,o1,o2,h9]);
            amino = new Amino([c1,c2,c3,c4,h1,h2,h3,h4,h5,h6,h7,h8,h9,n1,o1,o2,o3], [amine, carbo], "Threonine", "Thr", 'T', "polar", -0.7f);
            break;

        case "Tryptophan":
        case "tryptophan":
        case "Trp":
        case "trp":
        case "W":
            //Molecular formula     C11H12N2O2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           c7      = atomFactory("C");
            IAtom           c8      = atomFactory("C");
            IAtom           c9      = atomFactory("C");
            IAtom           c10     = atomFactory("C");
            IAtom           c11     = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           h12     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           n2      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",4u, c1, c2);
            IBond           b2      = bondFactory("covalent",c2, h1);
            IBond           b3      = bondFactory("covalent",c2, n1);
            IBond           b4      = bondFactory("covalent",n1, h2);
            IBond           b5      = bondFactory("covalent",n1, c3);
            IBond           b6      = bondFactory("covalent",4u, c3, c4);
            IBond           b7      = bondFactory("covalent",c4, c1);
            IBond           b8      = bondFactory("covalent",c3, c5);
            IBond           b9      = bondFactory("covalent",c5, h3);
            IBond           b10     = bondFactory("covalent",4u, c5, c6);
            IBond           b11     = bondFactory("covalent",c6, h4);
            IBond           b12     = bondFactory("covalent",c6, c7);
            IBond           b13     = bondFactory("covalent",c7, h5);
            IBond           b14     = bondFactory("covalent",4u, c7, c8);
            IBond           b15     = bondFactory("covalent",c8, h6);
            IBond           b16     = bondFactory("covalent",c8, c4);
            IBond           b17     = bondFactory("covalent",c1, c9);
            IBond           b18     = bondFactory("covalent",c9, h7);
            IBond           b19     = bondFactory("covalent",c9, h8);
            IBond           b20     = bondFactory("covalent",c9, c10);
            IBond           b21     = bondFactory("covalent",c10, h9);
            IBond           b22     = bondFactory("covalent",c10, n2);
            IBond           b23     = bondFactory("covalent",n2, h10);
            IBond           b24     = bondFactory("covalent",n2, h11);
            IBond           b25     = bondFactory("covalent",c10, c11);
            IBond           b26     = bondFactory("covalent",c11, o1);
            IBond           b27     = bondFactory("covalent",o1, h12);
            IBond           b28     = bondFactory("covalent",4u, c11, o2);
            ICompound       amine1  = compoundFactory("primary amine", [n2,h10,h11]);
            ICompound       amine2  = compoundFactory("secondary amine", [n1,h2]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c11,o1,o2,h12]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,n1,n2,o1,o2], [amine1, amine2, carbo], "Tryptophan", "Trp", 'W', "nonpolar", -0.9f);
            break;

        case "Tyrosine":
        case "tyrosine":
        case "Tyr":
        case "tyr":
        case "Y":
            //Molecular formula         C9H11NO3
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           c7      = atomFactory("C");
            IAtom           c8      = atomFactory("C");
            IAtom           c9      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, o1);
            IBond           b2      = bondFactory("covalent",o1, h1);
            IBond           b3      = bondFactory("covalent",4u, c1, c2);
            IBond           b4      = bondFactory("covalent",c2, h2);
            IBond           b5      = bondFactory("covalent",c2, c3);
            IBond           b6      = bondFactory("covalent",c3, h3);
            IBond           b7      = bondFactory("covalent",4u, c3, c4);
            IBond           b8      = bondFactory("covalent",c4, c5);
            IBond           b9      = bondFactory("covalent",c5, h4);
            IBond           b10     = bondFactory("covalent",4u, c5, c6);
            IBond           b11     = bondFactory("covalent",c6, h5);
            IBond           b12     = bondFactory("covalent",c6, c1);
            IBond           b13     = bondFactory("covalent",c4, c7);
            IBond           b14     = bondFactory("covalent",c7, h6);
            IBond           b15     = bondFactory("covalent",c7, h7);
            IBond           b16     = bondFactory("covalent",c7, c8);
            IBond           b17     = bondFactory("covalent",c8, h8);
            IBond           b18     = bondFactory("covalent",c8, n1);
            IBond           b19     = bondFactory("covalent",n1, h9);
            IBond           b20     = bondFactory("covalent",n1, h10);
            IBond           b21     = bondFactory("covalent",c8, c9);
            IBond           b22     = bondFactory("covalent",c9, o2);
            IBond           b23     = bondFactory("covalent",o2, h11);
            IBond           b24     = bondFactory("covalent",4u, c9, o3);
            ICompound       amine   = compoundFactory("primary amine", [n1,h9,h10]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c9,o2,o3,h11]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,c7,c8,c9,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,n1,o1,o2,o3], [amine, carbo], "Tyrosine", "Tyr", 'Y', "polar", -1.3f);
            break;

        case "Valine":
        case "valine":
        case "Val":
        case "val":
        case "V":
            //Molecular formula     C5H11NO2
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, c2);
            IBond           b4      = bondFactory("covalent",c2, h3);
            IBond           b5      = bondFactory("covalent",c2, c3);
            IBond           b6      = bondFactory("covalent",c3, h4);
            IBond           b7      = bondFactory("covalent",c3, h5);
            IBond           b8      = bondFactory("covalent",c2, c4);
            IBond           b9      = bondFactory("covalent",c4, h6);
            IBond           b10     = bondFactory("covalent",c4, n1);
            IBond           b11     = bondFactory("covalent",n1, h7);
            IBond           b12     = bondFactory("covalent",n1, h8);
            IBond           b13     = bondFactory("covalent",c4, c5);
            IBond           b14     = bondFactory("covalent",c5, o1);
            IBond           b15     = bondFactory("covalent",o1, h9);
            IBond           b16     = bondFactory("covalent",4u, c5, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h7,h8]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c5,o1,o2,h9]);
            amino = new Amino([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,n1,o1,o2], [amine, carbo], "Valine", "Val", 'V', "nonpolar", 4.2f);
            break;

        case "Selenocysteine":
        case "selenocysteine":
        case "Sec":
        case "sec":
        case "U":
            //Molecular formula         C3H7NO2Se
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           se1     = atomFactory("Se");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, h2);
            IBond           b3      = bondFactory("covalent",c1, se1);
            IBond           b4      = bondFactory("covalent",se1, h3);
            IBond           b5      = bondFactory("covalent",c1, c2);
            IBond           b6      = bondFactory("covalent",c2, h4);
            IBond           b7      = bondFactory("covalent",c2, n1);
            IBond           b8      = bondFactory("covalent",n1, h5);
            IBond           b9      = bondFactory("covalent",n1, h6);
            IBond           b10     = bondFactory("covalent",c2, c3);
            IBond           b11     = bondFactory("covalent",c3, o1);
            IBond           b12     = bondFactory("covalent",o1, h7);
            IBond           b13     = bondFactory("covalent",4u,c3, o2);
            ICompound       amine   = compoundFactory("primary amine", [n1,h5,h6]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c3,o1,o2,h7]);
            amino = new Amino([c1,c2,c3,h1,h2,h3,h4,h5,h6,h7,n1,o1,o2,se1], [amine, carbo], "Selenocysteine", "Sec", 'U', "unknow", 0f);
            break;

        case "Pyrrolysine":
        case "pyrrolysine":
        case "Pyl":
        case "pyl":
        case "O":
            //Molecular formula         C12H21N3O3
            IAtom           c1      = atomFactory("C");
            IAtom           c2      = atomFactory("C");
            IAtom           c3      = atomFactory("C");
            IAtom           c4      = atomFactory("C");
            IAtom           c5      = atomFactory("C");
            IAtom           c6      = atomFactory("C");
            IAtom           c7      = atomFactory("C");
            IAtom           c8      = atomFactory("C");
            IAtom           c9      = atomFactory("C");
            IAtom           c10     = atomFactory("C");
            IAtom           c11     = atomFactory("C");
            IAtom           c12     = atomFactory("C");
            IAtom           h1      = atomFactory("H");
            IAtom           h2      = atomFactory("H");
            IAtom           h3      = atomFactory("H");
            IAtom           h4      = atomFactory("H");
            IAtom           h5      = atomFactory("H");
            IAtom           h6      = atomFactory("H");
            IAtom           h7      = atomFactory("H");
            IAtom           h8      = atomFactory("H");
            IAtom           h9      = atomFactory("H");
            IAtom           h10     = atomFactory("H");
            IAtom           h11     = atomFactory("H");
            IAtom           h12     = atomFactory("H");
            IAtom           h13     = atomFactory("H");
            IAtom           h14     = atomFactory("H");
            IAtom           h15     = atomFactory("H");
            IAtom           h16     = atomFactory("H");
            IAtom           h17     = atomFactory("H");
            IAtom           h18     = atomFactory("H");
            IAtom           h19     = atomFactory("H");
            IAtom           h20     = atomFactory("H");
            IAtom           h21     = atomFactory("H");
            IAtom           n1      = atomFactory("N");
            IAtom           n2      = atomFactory("N");
            IAtom           n3      = atomFactory("N");
            IAtom           o1      = atomFactory("O");
            IAtom           o2      = atomFactory("O");
            IAtom           o3      = atomFactory("O");
            IBond           b1      = bondFactory("covalent",c1, h1);
            IBond           b2      = bondFactory("covalent",c1, c2);
            IBond           b3      = bondFactory("covalent",c2, h2);
            IBond           b4      = bondFactory("covalent",c2, c3);
            IBond           b5      = bondFactory("covalent",c3, h3);
            IBond           b6      = bondFactory("covalent",c3, h4);
            IBond           b7      = bondFactory("covalent",c3, h5);
            IBond           b8      = bondFactory("covalent",c2, c4);
            IBond           b9      = bondFactory("covalent",c4, h6);
            IBond           b10     = bondFactory("covalent",c4, h7);
            IBond           b11     = bondFactory("covalent",c4, c5);
            IBond           b12     = bondFactory("covalent",c5, h8);
            IBond           b13     = bondFactory("covalent",4u, c5, n1);
            IBond           b14     = bondFactory("covalent",n1, c1);
            IBond           b15     = bondFactory("covalent",c1, c6);
            IBond           b16     = bondFactory("covalent",4u, c6, o1);
            IBond           b17     = bondFactory("covalent",c6, n2);
            IBond           b18     = bondFactory("covalent",n2, h9);
            IBond           b19     = bondFactory("covalent",n2, c7);
            IBond           b20     = bondFactory("covalent",c7, h10);
            IBond           b21     = bondFactory("covalent",c7, h11);
            IBond           b22     = bondFactory("covalent",c7, c8);
            IBond           b23     = bondFactory("covalent",c8, h12);
            IBond           b24     = bondFactory("covalent",c8, h13);
            IBond           b25     = bondFactory("covalent",c8, c9);
            IBond           b26     = bondFactory("covalent",c9, h14);
            IBond           b27     = bondFactory("covalent",c9, h15);
            IBond           b28     = bondFactory("covalent",c9, c10);
            IBond           b29     = bondFactory("covalent",c10, h16);
            IBond           b30     = bondFactory("covalent",c10, h17);
            IBond           b31     = bondFactory("covalent",c10, c11);
            IBond           b32     = bondFactory("covalent",c11, h18);
            IBond           b33     = bondFactory("covalent",c11, n3);
            IBond           b34     = bondFactory("covalent",n3, h19);
            IBond           b35     = bondFactory("covalent",n3, h20);
            IBond           b36     = bondFactory("covalent",c11, c12);
            IBond           b37     = bondFactory("covalent",c12, o2);
            IBond           b38     = bondFactory("covalent",o2, h21);
            IBond           b39     = bondFactory("covalent",4u, c12, o3);
            ICompound       amine1  = compoundFactory("primary amine", [n3,h19,h20]);
            ICompound       amine2  = compoundFactory("secondary amine", [n2,h9]);
            ICompound       carbo   = compoundFactory("carboxylic acid", [c12,o2,o3,h21]);
            amino = new Amino([c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,n1,n2,n3,o1,o2,o3], [amine1, amine2, carbo], "Pyrrolysine", "Pyl", 'O', "unknow", 0f);
            break;

        case "Unknown":
        case "unknown":
        case "Xaa":
        case "xaa":
        case "X":
            amino = new Amino(null, "Unknow", "Xaa", 'x', "unknow", 0f);
            break;

        default:
            throw new UnknowAminoAcidException(aminoName, __FILE__, __LINE__);
    }
    return amino;
}

/**
 * return a list of amino acid
 */
 string aminoLetters(){
    return "ACDEFGHIKLMNPQRSTVWY".idup;
 }

/**
 * return a list of amino acid
 */
 string aminoLettersExtended(){
    return "ACDEFGHIKLMNOPQRSTUVWXY".idup;
 }
