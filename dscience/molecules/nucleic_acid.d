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
 * The module dscience.molecules.nucleic_acid is a set of function/definition around nucleic acid
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/molecules/nucleic_acid.d
 */
 module dscience.molecules.nucleic_acid;

import Convert = std.conv : to;
import std.string;

import dscience.physic.molecule;
import dscience.physic.bond;
import dscience.physic.atom;
import dscience.exception;

interface INucleic : IMolecule, ISymbol{
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
        ref ICompound[] compoundsList();

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
             * return shorter complement name
             */
            string complement();

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
             * return shorter name
             */
            char letter();

            /**
             * get x mean, y mean and z mean from molecule
             */
            double[] location();

            /**
             * return nucleic type, ie purine or pyrimidine
             */
            string type();

}

class Nucleic : INucleic{
    private:
        IMolecule   _molecule;
        char        _letter;
        string      _complement;
        string      _type;

    public:
        this(IAtom[] atoms, string name, char letter, string complement, string type){
            _molecule   = new Molecule(atoms, name);
            _letter     = letter;
            _complement = complement;
            _type       = type;
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
         * Add an Atom to molecule
         */
        void addAtom(IAtom atom, IBond bond){
            return _molecule.addAtom(atom, bond);
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
                return _molecule.atoms();
            }

            /**
             * Returns:
             * bond array
             */
            IBond[] bonds(){
                return _molecule.bonds;
            }

             /**
              * return shorter complement name
              */
            string complement(){
                return _complement.idup;
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
             * return shorter name
             */
             char letter(){
                return _letter;
             }

            /**
             * Returns:
             * number of max electron could have in last level from atom
             */
            size_t maxElectronInLastLevel(IAtom atom){
                return _molecule.maxElectronInLastLevel(atom);
            }
            /**
             * return nucleic type, ie purine or pyrimidine
             */
             string type(){
                return _type.idup;
             }

            /**
             * return molecule name
             */
            string name(){
                return _molecule.name();
            }

            /**
             * get x mean, y mean and z mean from molecule
             */
            double[] location(){
                return _molecule.location();
            }
}

Nucleic nucleicFactory(char nucleicName){
    return nucleicFactory(Convert.to!(string)(nucleicName));
}

Nucleic nucleicFactory(string nucleicName){
    Nucleic nucleic;
    switch(nucleicName){
        case "adenine":
        case "Adenine":
        case "a":
        case "A":
            //Molecular formula     C5H5N5
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
            IAtom           n1  = atomFactory("N");
            IAtom           n2  = atomFactory("N");
            IAtom           n3  = atomFactory("N");
            IAtom           n4  = atomFactory("N");
            IAtom           n5  = atomFactory("N");
            IBond           b1  = bondFactory("covalent", c1, n1);
            IBond           b2  = bondFactory("covalent", n1, h1);
            IBond           b3  = bondFactory("covalent", n1, h2);
            IBond           b4  = bondFactory("covalent", 4u, c1, n2);
            IBond           b5  = bondFactory("covalent", n2, c2);
            IBond           b6  = bondFactory("covalent", c2, h3);
            IBond           b7  = bondFactory("covalent", 4u, c2, n3);
            IBond           b8  = bondFactory("covalent", n3, c3);
            IBond           b9  = bondFactory("covalent", 4u, c3, c4);
            IBond           b10 = bondFactory("covalent", c4, c1);
            IBond           b11 = bondFactory("covalent", c3, n4);
            IBond           b12 = bondFactory("covalent", n4, h4);
            IBond           b13 = bondFactory("covalent", n4, c5);
            IBond           b14 = bondFactory("covalent", c5, h5);
            IBond           b15 = bondFactory("covalent", 4u, c5, n5);
            IBond           b16 = bondFactory("covalent", n5, c4);
            nucleic             = new Nucleic([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,n1,n2,n3,n4,n5], "Adenine",'A', ['T','U'], "purine");
            break;
        case "cytosine":
        case "Cytosine":
        case "c":
        case "C":
            //Molecular formula     C4H5N3O
            IAtom           c1  = atomFactory("C");
            IAtom           c2  = atomFactory("C");
            IAtom           c3  = atomFactory("C");
            IAtom           c4  = atomFactory("C");
            IAtom           h1  = atomFactory("H");
            IAtom           h2  = atomFactory("H");
            IAtom           h3  = atomFactory("H");
            IAtom           h4  = atomFactory("H");
            IAtom           h5  = atomFactory("H");
            IAtom           n1  = atomFactory("N");
            IAtom           n2  = atomFactory("N");
            IAtom           n3  = atomFactory("N");
            IAtom           o1  = atomFactory("O");
            IBond           b1  = bondFactory("covalent", c1, n1);
            IBond           b2  = bondFactory("covalent", n1, h1);
            IBond           b3  = bondFactory("covalent", n1, h2);
            IBond           b4  = bondFactory("covalent", 4u, c1, n2);
            IBond           b5  = bondFactory("covalent", n2, c3);
            IBond           b6  = bondFactory("covalent", c3, o1);
            IBond           b7  = bondFactory("covalent", c3, n3);
            IBond           b8  = bondFactory("covalent", n3, h3);
            IBond           b9  = bondFactory("covalent", n3, c3);
            IBond           b10 = bondFactory("covalent", 4u, c3, c4);
            IBond           b11 = bondFactory("covalent", c4, c1);
            nucleic             = new Nucleic([c1,c2,c3,c4,h1,h2,h3,h4,h5,n1,n2,n3,o1], "Cytosine", 'C', "G", "pyrimidine");
            break;
        case "guanine":
        case "Guanine":
        case "g":
        case "G":
            //Molecular formula         C5H5N5O
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
            IAtom           n1  = atomFactory("N");
            IAtom           n2  = atomFactory("N");
            IAtom           n3  = atomFactory("N");
            IAtom           n4  = atomFactory("N");
            IAtom           n5  = atomFactory("N");
            IAtom           o1  = atomFactory("O");
            IBond           b1  = bondFactory("covalent", 4u, c1, o1);
            IBond           b2  = bondFactory("covalent", c1, n1);
            IBond           b3  = bondFactory("covalent", n1, h1);
            IBond           b4  = bondFactory("covalent", n1, c2);
            IBond           b5  = bondFactory("covalent", c2, n2);
            IBond           b6  = bondFactory("covalent", n2, h2);
            IBond           b7  = bondFactory("covalent", n2, h3);
            IBond           b8  = bondFactory("covalent", 4u, n2, n3);
            IBond           b9  = bondFactory("covalent", n3, c3);
            IBond           b10 = bondFactory("covalent", 4u, c3, c4);
            IBond           b11 = bondFactory("covalent", c4, c1);
            IBond           b12 = bondFactory("covalent", c3, n4);
            IBond           b13 = bondFactory("covalent", n4, c5);
            IBond           b14 = bondFactory("covalent", 4u, c5, n5);
            IBond           b15 = bondFactory("covalent", c5, h4);
            IBond           b16 = bondFactory("covalent", n5, h5);
            IBond           b17 = bondFactory("covalent", n5, c4);
            nucleic             = new Nucleic([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,n1,n2,n3,n4,n5,o1], "Guanine", 'G', "C", "purine");
            break;
        case "thymine":
        case "Thymine":
        case "t":
        case "T":
            //Molecular formula     C5H6N2O2
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
            IAtom           n1  = atomFactory("N");
            IAtom           n2  = atomFactory("N");
            IAtom           o1  = atomFactory("O");
            IAtom           o2  = atomFactory("O");
            IBond           b1  = bondFactory("covalent", 4u, c1, o1);
            IBond           b2  = bondFactory("covalent", c1, n1);
            IBond           b3  = bondFactory("covalent", n1, h1);
            IBond           b4  = bondFactory("covalent", n1, c2);
            IBond           b5  = bondFactory("covalent", 4u, c2, o2);
            IBond           b6  = bondFactory("covalent", c2, n2);
            IBond           b7  = bondFactory("covalent", n2, h2);
            IBond           b8  = bondFactory("covalent", n2, c3);
            IBond           b9  = bondFactory("covalent", c3, h3);
            IBond           b10 = bondFactory("covalent", 4u, c3, c4);
            IBond           b11 = bondFactory("covalent", c4, c5);
            IBond           b12 = bondFactory("covalent", c5, h4);
            IBond           b13 = bondFactory("covalent", c5, h5);
            IBond           b14 = bondFactory("covalent", c5, h6);
            IBond           b15 = bondFactory("covalent", c4, c1);
            nucleic             = new Nucleic([c1,c2,c3,c4,c5,h1,h2,h3,h4,h5,h6,n1,n2,o1,o2], "Thymine", 'T', "A", "pyrimidine");
            break;
        case "uracil":
        case "Uracil":
        case "u":
        case "U":
            //Molecular formula     C4H4N2O2
            IAtom           c1  = atomFactory("C");
            IAtom           c2  = atomFactory("C");
            IAtom           c3  = atomFactory("C");
            IAtom           c4  = atomFactory("C");
            IAtom           h1  = atomFactory("H");
            IAtom           h2  = atomFactory("H");
            IAtom           h3  = atomFactory("H");
            IAtom           h4  = atomFactory("H");
            IAtom           n1  = atomFactory("N");
            IAtom           n2  = atomFactory("N");
            IAtom           o1  = atomFactory("O");
            IAtom           o2  = atomFactory("O");
            IBond           b1  = bondFactory("covalent", 4u, c1, o1);
            IBond           b2  = bondFactory("covalent", c1, n1);
            IBond           b3  = bondFactory("covalent", n1, h1);
            IBond           b4  = bondFactory("covalent", n1, c2);
            IBond           b5  = bondFactory("covalent", 4u, c2, o2);
            IBond           b6  = bondFactory("covalent", c2, n2);
            IBond           b7  = bondFactory("covalent", n2, h2);
            IBond           b8  = bondFactory("covalent", n2, c3);
            IBond           b9  = bondFactory("covalent", c3, h3);
            IBond           b10 = bondFactory("covalent", 4u, c3, c4);
            IBond           b11 = bondFactory("covalent", c4, h4);
            IBond           b12 = bondFactory("covalent", c4, c1);
            nucleic             = new Nucleic([c1,c2,c3,c4,h1,h2,h3,h4,n1,n2,o1,o2], "Uracil", 'U', "A", "pyrimidine");
            break;
        default:
            throw new UnknowNucleicAcidException(__FILE__, __LINE__);
    }
    return nucleic;
}

/**
 * nucleic acid letters
 */
enum string nucleicLetters  = "ACGTU";

/**
 * nucleic acid letters
 */
enum string dnaLetters      =  "ACGT";

/**
 * nucleic acid letters
 */
enum string rnaLetters      =  "ACGU";


/**
 * IUPAC
 */
 enum    char[][char] iupac = ['A':['A'], 'C':['C'] , 'G':['G'], 'T':['T'], 'U':['U'], 'W':['A', 'T'], 'S':['C', 'G'], 'M':['A', 'C'], 'K':['G', 'T'], 'R':['A', 'G'], 'Y':['C', 'T'], 'B':['C', 'G', 'T'], 'D':['A', 'G', 'T'], 'H':['A', 'C', 'T'], 'V':['A', 'C', 'G'], 'N':['A', 'C', 'G', 'T'], '-':['A', 'C', 'G', 'T']];
