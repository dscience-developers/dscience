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
 * Saccharide definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/molecules/saccharide.d
 */
module dscience.molecules.saccharide;

import std.string;

import dscience.physic.molecule;
import dscience.exception;
import dscience.physic.bond;
import dscience.physic.atom;
import dscience.exception;



interface ISaccharide : IMolecule{
    public:
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
        ref ICompound[] compounds(string[] types...);

        /**
         * return compound
         */
        ICompound compound(size_t compoundId);

        /**
         * get x , y and z from atom
         */
        double[] getAtomLocation(IAtom atom);

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
             * return categorie name
             */
            string categorie();

            /**
             * Returns:
             * compounds array
             */
            ref ICompound[] compoundsList();

            /**
             * return mean electronegativity
             */
            float electronegativity();

            /**
             * return group name
             */
            string group();

            /**
             * get x mean, y mean and z mean from molecule
             */
            double[] location();

            /**
             * Returns:
             * number of max electron could have in last level from atom
             */
            size_t maxElectronInLastLevel(IAtom atom);

}

class Saccharide : ISaccharide{
    private:
        IMolecule   _molecule;
        string      _group;
        string      _categorie;

    public:
        this(IAtom[] atoms, string name, string group, string categorie){
            _molecule   = new Molecule(atoms, name);
            _group      = group;
            _categorie  = categorie;
        }

        /**
         * get x , y and z from atom
         */
        double[] getAtomLocation(IAtom atom){
            return _molecule.getAtomLocation(atom);
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
         * Returns:
         * number of max electron could have in last level from atom
         */
        size_t maxElectronInLastLevel(IAtom atom){
            return _molecule.maxElectronInLastLevel(atom);
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
         * get x , y and z from atom
         */
        double[] location(IAtom atom){
            return _molecule.getAtomLocation(atom);
        }

        /**
         *  remove atom from molecule
         */
        void remove(IAtom[] atom ...){
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
             * return categorie name
             */
            string categorie(){
                return _categorie.idup;
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
             * return group name
             */
            string group(){
                return _group.idup;
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

Saccharide saccharideFactory(string saccharideName, string environments="wtery"){
    Saccharide saccharide = null;
    switch(saccharideName){
        case "Glyceraldehyde":
        case "glyceraldehyde":
            //Molecular formula     C3H6O3
            IAtom           c1  = atomFactory("C");
            IAtom           c2  = atomFactory("C");
            IAtom           c3  = atomFactory("C");
            IAtom           h1  = atomFactory("H");
            IAtom           h2  = atomFactory("H");
            IAtom           h3  = atomFactory("H");
            IAtom           h4  = atomFactory("H");
            IAtom           h5  = atomFactory("H");
            IAtom           h6  = atomFactory("H");
            IAtom           o1  = atomFactory("O");
            IAtom           o2  = atomFactory("O");
            IAtom           o3  = atomFactory("O");
            IBond           b1  = bondFactory("covalent", c1, h1);
            IBond           b2  = bondFactory("covalent", c1, h2);
            IBond           b3  = bondFactory("covalent", c1, o1);
            IBond           b4  = bondFactory("covalent", o1, h3);
            IBond           b5  = bondFactory("covalent", c1, c2);
            IBond           b6  = bondFactory("covalent", c2, h4);
            IBond           b7  = bondFactory("covalent", c2, o2);
            IBond           b8  = bondFactory("covalent", o2, h5);
            IBond           b9  = bondFactory("covalent", c2, c3);
            IBond           b10 = bondFactory("covalent", c3, h6);
            IBond           b11 = bondFactory("covalent", 4u, c3, o3);
            saccharide          = new Saccharide([c1,c2,c3,h1,h2,h3,h4,h5,h6,o1,o2,o3], "Glyceraldehyde", "Aldoses", "Aldotriose");
        break;
        case "Erythrose":
        case "erythrose":
            //Molecular formula     C4H8O4
            IAtom           c1  = atomFactory("C");
            IAtom           c2  = atomFactory("C");
            IAtom           c3  = atomFactory("C");
            IAtom           c4  = atomFactory("C");
            IAtom           h1  = atomFactory("H");
            IAtom           h2  = atomFactory("H");
            IAtom           h3  = atomFactory("H");
            IAtom           h4  = atomFactory("H");
            IAtom           h5  = atomFactory("H");
            IAtom           h6  = atomFactory("H");
            IAtom           h7  = atomFactory("H");
            IAtom           h8  = atomFactory("H");
            IAtom           o1  = atomFactory("O");
            IAtom           o2  = atomFactory("O");
            IAtom           o3  = atomFactory("O");
            IAtom           o4  = atomFactory("O");
            IBond           b1  = bondFactory("covalent", c1, h1);
            IBond           b2  = bondFactory("covalent", c1, h2);
            IBond           b3  = bondFactory("covalent", c1, o1);
            IBond           b4  = bondFactory("covalent", o1, h3);
            IBond           b5  = bondFactory("covalent", c1, c2);
            IBond           b6  = bondFactory("covalent", c2, h4);
            IBond           b7  = bondFactory("covalent", c2, o2);
            IBond           b8  = bondFactory("covalent", o2, h5);
            IBond           b9  = bondFactory("covalent", c2, c3);
            IBond           b10 = bondFactory("covalent", c3, h6);
            IBond           b11 = bondFactory("covalent", c3, o3);
            IBond           b12 = bondFactory("covalent", o3, h7);
            IBond           b13 = bondFactory("covalent", c3, c4);
            IBond           b14 = bondFactory("covalent", c4, h8);
            IBond           b15 = bondFactory("covalent", 4u, c4, o4);
            saccharide          = new Saccharide([c1,c2,c3,c4,h1,h2,h3,h4,h5,h6,h7,h8,o1,o2,o3,o4], "Erythrose", "Aldoses", "Aldotetroses");
        break;
        case "Threose":
        case "threose":
            //Molecular formula     C4H8O4
            IAtom           c1  = atomFactory("C");
            IAtom           c2  = atomFactory("C");
            IAtom           c3  = atomFactory("C");
            IAtom           c4  = atomFactory("C");
            IAtom           h1  = atomFactory("H");
            IAtom           h2  = atomFactory("H");
            IAtom           h3  = atomFactory("H");
            IAtom           h4  = atomFactory("H");
            IAtom           h5  = atomFactory("H");
            IAtom           h6  = atomFactory("H");
            IAtom           h7  = atomFactory("H");
            IAtom           h8  = atomFactory("H");
            IAtom           o1  = atomFactory("O");
            IAtom           o2  = atomFactory("O");
            IAtom           o3  = atomFactory("O");
            IAtom           o4  = atomFactory("O");
            IBond           b1  = bondFactory("covalent", c1, h1);
            IBond           b2  = bondFactory("covalent", c1, h2);
            IBond           b3  = bondFactory("covalent", c1, o1);
            IBond           b4  = bondFactory("covalent", o1, h3);
            IBond           b5  = bondFactory("covalent", c1, c2);
            IBond           b6  = bondFactory("covalent", c2, h4);
            IBond           b7  = bondFactory("covalent", c2, o2);
            IBond           b8  = bondFactory("covalent", o2, h5);
            IBond           b9  = bondFactory("covalent", c2, c3);
            IBond           b10 = bondFactory("covalent", c3, h6);
            IBond           b11 = bondFactory("covalent", c3, o3);
            IBond           b12 = bondFactory("covalent", o3, h7);
            IBond           b13 = bondFactory("covalent", c3, c4);
            IBond           b14 = bondFactory("covalent", c4, h8);
            IBond           b15 = bondFactory("covalent", 4u, c4, o4);
            saccharide          = new Saccharide([c1,c2,c3,c4,h1,h2,h3,h4,h5,h6,h7,h8,o1,o2,o3,o4], "Threose", "Aldoses", "Aldotetroses");
        break;
        case "Ribose":
        case "ribose":
            switch(environments){
                case "watery":
                default: //TODO
                    //Molecular formula     C5H10O5
                    IAtom           c1  = atomFactory("C");
                    IAtom           c2  = atomFactory("C");
                    IAtom           c3  = atomFactory("C");
                    IAtom           c4  = atomFactory("C");
                    IAtom           c5  = atomFactory("C");
                    IAtom           h1  = atomFactory("H");
                    IAtom           h2  = atomFactory("H");
                    IAtom           h3  = atomFactory("H");
                    IAtom           h4  = atomFactory("H");
                    IAtom           h5  = atomFactory("H");
                    IAtom           h6  = atomFactory("H");
                    IAtom           h7  = atomFactory("H");
                    IAtom           h8  = atomFactory("H");
                    IAtom           h9  = atomFactory("H");
                    IAtom           h10 = atomFactory("H");
                    IAtom           o1  = atomFactory("O");
                    IAtom           o2  = atomFactory("O");
                    IAtom           o3  = atomFactory("O");
                    IAtom           o4  = atomFactory("O");
                    IAtom           o5  = atomFactory("O");
                    IBond           b1  = bondFactory("covalent", c1, h1);
                    IBond           b2  = bondFactory("covalent", c1, o1);
                    IBond           b3  = bondFactory("covalent", o1, h2);
                    IBond           b4  = bondFactory("covalent", c1, c2);
                    IBond           b5  = bondFactory("covalent", c2, h3);
                    IBond           b6  = bondFactory("covalent", c2, o2);
                    IBond           b7  = bondFactory("covalent", o2, h4);
                    IBond           b8  = bondFactory("covalent", c2, c3);
                    IBond           b9  = bondFactory("covalent", c3, h5);
                    IBond           b10 = bondFactory("covalent", c3, o3);
                    IBond           b11 = bondFactory("covalent", o3, h6);
                    IBond           b12 = bondFactory("covalent", c3, c4);
                    IBond           b13 = bondFactory("covalent", c4, h7);
                    IBond           b14 = bondFactory("covalent", c4, c5);
                    IBond           b15 = bondFactory("covalent", c5, h8);
                    IBond           b16 = bondFactory("covalent", c5, h9);
                    IBond           b17 = bondFactory("covalent", c5, o4);
                    IBond           b18 = bondFactory("covalent", o4, h10);
                    IBond           b19 = bondFactory("covalent", c4, o5);
                    IBond           b20 = bondFactory("covalent", o5, c1);
                    saccharide          = new Saccharide([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,o1,o2,o3,o4,o5], "Riose", "Aldoses", "Aldopentoses");
                break;
            }
            break;
        default:
            throw new UnknowSaccharideException( saccharideName, __FILE__, __LINE__ );
    }
    return saccharide;
}
