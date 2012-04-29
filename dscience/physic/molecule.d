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
 * Molecule definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/physic/molecule.d
 */

module dscience.physic.molecule;

import std.string;
import Math = std.math;

import dscience.physic.atom;
import dscience.physic.bond;
import dscience.exception;

interface ISymbol{
    public @property char letter();
}

interface IMolecule{
    public:
        /**
         * Add an Atom to molecule
         */
        void addAtom(IAtom atom, IBond bond);

        /**
         * return compound
         */
        ICompound compound(size_t compoundId);

        /**
         * return compound list
         */
        ref ICompound[] compounds(string[] types...);

        /**
         * Returns:
         * compounds array
         */
        ref ICompound[] compoundsList();

        /**
         * return atom list
         */
        IAtom[] findAtoms(string type);

        /**
         * get x , y and z from atom
         */
        double[] getAtomLocation(IAtom atom);

        /**
         *  remove atom from molecule
         */
        void remove(IAtom[] atom ...);

        /**
         * set x , y and z from atom
         */
        void setAtomLocation(IAtom atom, double x, double y, double z);

        /**
         * set x , y and z from atom
         */
        void setAtomLocation(string type, size_t atomNum, double x, double y, double z);

        @property:
            /**
             * Returns:
             * atoms array
             */
            ref IAtom[] atoms();

            /**
             * Returns:
             * bond array
             */
            IBond[] bonds();

            /**
             * return mean electronegativity
             */
            float electronegativity();

            /**
             * get x mean, y mean and z mean from molecule
             */
            double[] location();

            /**
             * Returns:
             * number of max electron could have in last level from atom
             */
            size_t maxElectronInLastLevel(IAtom atom);

            /**
             * return molecule name
             */
            string name();


}

class Molecule : IMolecule{
    private:
        IAtom[]         _atoms;      //atom list
        string          _name;
        ICompound[]     _compounds;  // compound list
        /**
         * check if each atom do a correct number of bond
         */
        void checkAtomsBonds(){
            foreach(atom; _atoms){
                checkAtomBond(atom);
            }
        }
        /**
         * check if an atom do a correct number of bond
         */
        void checkAtomBond(IAtom atom){
            uint electronUsed = 0;
            foreach(IBond bond; atom.bonds()){
                electronUsed += bond.electronNeed()/2;
            }
            if(electronUsed > atom.maxElectronInLastLevel )
                throw new AtomBondException(atom, __FILE__, __LINE__);
        }

        /**
         * return index position of atom
         */
        size_t findAtom(IAtom atom){
            bool    isSearching = true;
            size_t  index       = 0;
            while(isSearching){
                if(index == _atoms.length){
                    isSearching = false;
                    throw new AtomNotFoundException(atom, __FILE__, __LINE__);
                }
                else{
                    if(_atoms[index] is atom){
                        isSearching = false;
                    }
                    else
                        index++;
                }
            }
            return index;
        }

        /**
         * return index position of atom
         */
        size_t findAtom(string type, size_t atomNum){
            bool    isSearching = true;
            size_t  index       = 0;
            size_t  num         = 0;
            while(isSearching){
                if(index == _atoms.length){
                    isSearching = false;
                    throw new AtomNotFoundException(type, atomNum, __FILE__, __LINE__);
                }
                else{
                    if(_atoms[index].symbol == type){
                        num++;
                        if(num == atomNum)
                            isSearching = false;
                        else
                            index++;
                    }
                    else
                        index++;
                }
            }
            return index;
        }

        /**
         * Returns:
         *  an array who conatain index of bonds array where atom is found
         */
        size_t[] findAtomInBond(size_t idAtom){
            bool isSearching    = true;
            size_t[] indexArray;
            indexArray.length   = 10;
            size_t index        = 0;
            foreach(indexBond,bond; bonds() ){
                if(index == indexArray.length)
                    indexArray.length = indexArray.length +10;
                int result = bond.isLinkWith(idAtom);
                if( result != -1){
                    indexArray[index] = indexBond;
                    index++;
                }
            }
            return indexArray;
        }

        /**
         * return compound list
         */
        ICompound[] compoundsList(string type){
            ICompound[] compounds   = new ICompound[](_compounds.length);
            size_t      arrayLength = 0;
            foreach(compound; _compounds){
                if(compound.className == type){
                    compounds[arrayLength] = compound;
                    arrayLength++;
                }
            }
            compounds.length = arrayLength;
            return compounds;
        }


        void removeAtoms(size_t[] atomIndex){
            foreach(i; atomIndex){
                IAtom[] tmp1        = _atoms[0..i];
                IAtom[] tmp2        = _atoms[i+1..$];
                atoms               = new IAtom[](tmp1.length+tmp2.length);
                atoms               = tmp1~tmp2;
            }
        }

        void removeCompounds(size_t[] compoundIndex){
            foreach(i; compoundIndex){
                ICompound[] tmp1    = _compounds[0..i];
                ICompound[] tmp2    = _compounds[i+1..$];
                compounds           = new ICompound[](tmp1.length+tmp2.length);
                compounds           = tmp1~tmp2;
            }
        }

    public:
        this(IAtom[] atoms, string name){
            _atoms      = atoms;
            _name       = name;
            _compounds  = null;
            checkAtomsBonds();
        }

        this(IAtom[] atoms, ICompound[] compounds, string name){
            _atoms      = atoms;
            _name       = name;
            _compounds  = compounds;
            checkAtomsBonds();
        }

        /**
         * Add an Atom to molecule
         */
        void addAtom(IAtom atom, IBond bond){
            //check if they are not too bond for this atom
            checkAtomBond(atom);
            //Add new atom to molecule
            _atoms.length               = _atoms.length + 1;
            _atoms[atoms.length - 1]    = atom;
            //Search at which atom is linked
            IAtom[] atomList            = bond.atoms();
            size_t id                   = 0;
            if (atomList[0].atomId() == atom.atomId ){
                id = atomList[1].atomId();
            }
            else if (atomList[1].atomId == atom.atomId ){
                id = atomList[0].atomId;
            }
            else
                throw new AtomBondException("Impossible to bound atom, one or more atom id is not present in the molecule", __FILE__, __LINE__);
            size_t index                = findAtom(atom);
            //Add bond to this atom
            _atoms[index].addBond(bond);
            //check if they are not too bond for this atom
            checkAtomBond(_atoms[index]);
        }

        /**
         * return compound
         */
        ICompound compound(size_t compoundId){
            bool        isSearching = true;
            ICompound   compound    = null;
            size_t index    = 0;
            while(isSearching){
                if(index == _compounds.length)
                    isSearching = false;
                else{
                    if(_compounds[index].compoundId == compoundId){
                        isSearching = false;
                        compound    = _compounds[index];
                    }
                    else
                        index++;
                }
            }
            return compound;
        }

        ref ICompound[] compounds(string[] types...){
            ICompound[] currentCompounds = new ICompound[](0);
            foreach(string type; types){
                currentCompounds ~= compoundsList(type);
            }
            return compounds;
        }

        ref ICompound[] compoundsList(){
            return _compounds;
        }

        /**
         * return atom list
         */
        IAtom[] findAtoms(string type){
            size_t  index       = 0;
            IAtom[] atomList    = new IAtom[](5);
            foreach(atom; _atoms){
                if(atom.symbol == type){
                    if(index == atomList.length)
                        atomList.length = atomList.length + 10;
                    atomList[index] = atom;
                    index++;
                }
            }
            atomList.length = index;
            if(atomList.length == 0)
                throw new AtomNotFoundException(type, __FILE__, __LINE__);
            return atomList;
        }


        /**
         * get x , y and z from atom
         */
        double[] getAtomLocation(IAtom atom){
            return _atoms[findAtom(atom)].location();
        }

        /**
         * set x , y and z from atom
         */
         void setAtomLocation(IAtom atom, double x, double y, double z){
            _atoms[findAtom(atom)].location(x, y, z);
         }

         /**
         * set x , y and z from atom
         */
         void setAtomLocation(string type, size_t atomNum, double x, double y, double z){
            _atoms[findAtom(type, atomNum)].location(x, y, z);
         }

        /**
         *  remove atom from molecule
         */
        void remove(IAtom[] atoms ...){
            size_t[]    atomIndex           = new size_t[](0);
            size_t[]    compoundIndex       = new size_t[](0);
            size_t      removeAtomNumber    = 0;
            size_t      removecompoundNumber= 0;

            foreach(IAtom atom; _atoms){
                size_t index = findAtom(atom);
                if(index < _atoms.length - 1){
                    atomIndex ~= index - removeAtomNumber;
                    removeAtomNumber++;
                }
                else{
                    _atoms.length = _atoms.length - 1;
                }
                foreach(i,compound; _compounds){
                    if(compound.isPresent(atom)){ // remove compound
                        if(i < _compounds.length - 1){
                            compoundIndex ~= i - removecompoundNumber;
                            removecompoundNumber++;
                        }
                        else{
                            _compounds.length = _compounds.length - 1;
                        }
                    }
                }
                atom.removeAllBonds();
                removeAtoms(atomIndex);
                removeCompounds(compoundIndex);
            }
        }

        @property:

            ref IAtom[] atoms(){
                return _atoms;
            }

            /**
             * Returns:
             * bond array
             */
            IBond[] bonds(){
                size_t currentSize  = atoms.length;
                IBond[] bondsList   = new IBond[](currentSize);
                foreach(IAtom atom ; _atoms){
                    foreach(index, IBond currentBond ; atom.bonds){
                        if(currentSize == bondsList.length)
                            bondsList.length= bondsList.length + 10;
                        bondsList[index] = currentBond;
                        currentSize++;
                    }
                }
                bondsList.length = currentSize;
                return bondsList;
            }

            /**
             * return mean electronegativity
             */
            float electronegativity(){
                float electronegativity = 0;
                foreach( atom; _atoms){
                    electronegativity += atom.electronegativity;
                }
                return electronegativity/_atoms.length;
            }

            /**
             * get x mean, y mean and z mean from molecule
             */
            double[] location(){
                double x = 0;
                double y = 0;
                double z = 0;
                foreach(atom; _atoms){
                    x += atom.x;
                    y += atom.y;
                    z += atom.z;
                }
                return [(x/_atoms.length), (y/_atoms.length), (z/_atoms.length)];
            }

            /**
             * Returns:
             * number of max electron could have in last level from atom
             */
            size_t maxElectronInLastLevel(IAtom atom){
                return _atoms[findAtom(atom)].maxElectronInLastLevel;
            }

            /**
             * return molecule name
             */
            string name(){
                return _name.idup;
            }

}

interface ICompound{
    public:
        bool     isPresent(IAtom atom);
        @property:
            string   className();
            string   group();
            string   prefix();
            string   suffix();
            IAtom[]  find(string type);
            size_t   compoundId();
}


class Compound : ICompound{
    private:
        static size_t   _numberOfCompound;
        const size_t    _compoundId;
        string          _className;
        string          _groupName;
        string          _prefix;
        string          _suffix;
        IAtom[]         _atoms;

    public:
        this(string className, string groupName, string prefix, string suffix, IAtom[] atoms){
            _className  = className;
            _groupName  = groupName;
            _prefix     = prefix;
            _suffix     = suffix;
            _atoms      = atoms;
            _compoundId = _numberOfCompound;
            _numberOfCompound++;
        }

        IAtom[] find(string type){
            IAtom[] atomList    = new IAtom[](_atoms.length);
            size_t arrayLength  = 0;
            foreach(atom; _atoms){
                if(atom.symbol == type){
                    atomList[arrayLength] = atom;
                    arrayLength++;
                }
            }
            atomList.length = arrayLength;
            return atomList;
        }

        bool isPresent(IAtom atom){
            bool    isPresent   = false;
            bool    isSearching = true;
            size_t  index       = 0;
            while(isSearching){
                if(index == _atoms.length)
                    isSearching = false;
                else if(_atoms[index] is atom){
                    isSearching = false;
                    isPresent  = true;
                }
                index++;
            }
            return isPresent;
        }

        @property:
            string className(){
                return _className.idup;
            }

            size_t compoundId(){
                return _compoundId;
            }

            string group(){
                return _groupName.idup;
            }

            string prefix(){
                return _prefix.idup;
            }

            string suffix(){
                return _suffix.idup;
            }
}

/**
 * compoundFactory
 * See_Also:
 *  http://en.wikipedia.org/wiki/Functional_group
 */
ICompound compoundFactory(string compoundName, IAtom[] atoms){
    Compound compound = null;
    switch(compoundName){
        case "alcohol":
            compound = new Compound(compoundName, "hydroxyl",           "hydroxy-",     "-ol",                  atoms); // ROH
            break;
        case "ketone":
            compound = new Compound(compoundName, "carbonyl",           "keto-,oxo-",   "-one",                 atoms); // RORCOR'H
            break;
        case "aldehyde":
            compound = new Compound(compoundName, "aldehyde",           "formyl-",      "-al",                  atoms); // RCHO
            break;
        case "acyl halide":
            compound = new Compound(compoundName, "haloformyl",         "haloformyl-",  "-oyl halide",          atoms); // RCOX
            break;
        case "carbonate":
            compound = new Compound(compoundName, "carbonate ester",    "",             "alkyl carbonate",      atoms); // ROCOOR
            break;
        case "carboxylate":
            compound = new Compound(compoundName, "carboxylate",        "carboxy-",     "-oate",                atoms); // RCOO−
            break;
        case "carboxylic acid":
            compound = new Compound(compoundName, "carboxyl",           "carboxy-",     "-oic acid",            atoms); // RCOOH
            break;
        case "ether":
            compound = new Compound(compoundName, "ether",              "alkoxy-",      "-ether",               atoms); // ROR'
            break;
        case "ester":
            compound = new Compound(compoundName, "Ester",              "alkanoyloxy-", "alkyl alkanoate",      atoms); // RCOOR'
            break;
        case "hydroperoxide":
            compound = new Compound(compoundName, "hydroperoxy",        "hydroperoxy-", "alkyl hydroperoxide",  atoms); // ROOH
            break;
        case "peroxide":
            compound = new Compound(compoundName, "peroxy",             "peroxy-",      "alkyl peroxide",       atoms); // ROOR
            break;
        case "alkane":
            compound = new Compound(compoundName, "alkyl",              "alkyl-",       "-ane",                 atoms); // RH
            break;
        case "alkene":
            compound = new Compound(compoundName, "alkynyl",            "alkynyl-",     "-yne",                 atoms); // RC≡CR'
            break;
        case "benzene derivative":
            compound = new Compound(compoundName, "phenyl",             "phenyl-",      "benzene",              atoms); // RC6H5RPh
            break;
        case "toluene derivative":
            compound = new Compound(compoundName, "benzyl",             "benzyl-",      "1-...toluene",         atoms); // RCH2C6H5RBn
            break;
        case "primary amine":
            compound = new Compound(compoundName, "primary amine",      "amino-",       "-amine",               atoms); // RNH2
            break;
        case "secondary amine":
            compound = new Compound(compoundName, "secondary amine",   "amino-",       "-amine",                atoms); // R2NH
            break;
        case "tertiary amine amine":
            compound = new Compound(compoundName, "tertiary amine",     "amino-",       "-amine",               atoms); // R3N
            break;
        case "ammonium ion":
            compound = new Compound(compoundName, "ammonium  ion",      "ammonio-",     "-ammonium",            atoms); // R4N
            break;
        case "amide":
            compound = new Compound(compoundName, "amide",              "carboxamido-", "-amide",               atoms); // RCONR2
            break;
        case "thiol":
            compound = new Compound(compoundName, "sulfhydryl",         "sulfanyl-",    "-thiol",               atoms); // RSH
            break;
        default:
            throw new UnknowCompoundException( compoundName, __FILE__, __LINE__ );
    }
    return compound;
}
