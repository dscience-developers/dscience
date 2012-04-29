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
 * Atom definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/physic/atom.d
 */

module dscience.physic.atom;

import dscience.physic.bond;
import dscience.physic.fermion;
import dscience.exception;
import std.math;

interface IAtom{
    public:
        double[]         location();

        void             location(double x, double y, double z);

        void             moveTo(double[] location);

        bool             containBond(size_t idBond);

        void             addBond(IBond idBond);

        void             removeBond(IBond bond);

        void             removeAllBonds();

        /**
         * Returns:
         * 0 if atom is in index array 0
         * 1 if atom is in index array 1
         * -1 if atom are not here
         */
        int             isLinkWith(size_t id);

        IAtom[]         linkedWith();

        @property:
            uint                    atomicNumber();

            uint                    massNumber();

            ref Proton[]            protonList();

            ref Neutron[]           neutronList();

            ref Electron[][char]    electronCloud();

            float                   electronegativity();

            float                   vanDerWaalsRadius();

            float                   atomicRadius();

            float                   covalentRadius();

            string                  name();

            string                  symbol();

            IBond[]                 bonds();

            string                  group();

            size_t                  atomId();

            size_t                  maxElectronInLastLevel();

            size_t                  numberOfBond();

            double                  x();

            double                  y();

            double                  z();

            void                    x(double value);

            void                    y(double value);

            void                    z(double value);

            double                  electricCharge();

            double                  mass();

}

class Atom : IAtom{
    private:
        uint                _atomicNumber;      //A
        uint                _massNumber;        //Z
        static size_t       _numberOfAtom;
        const size_t        _atomId;
        Proton[]            _protons;
        Neutron[]           _neutrons;
        Electron[][char]    _electronCloud;
        const string        _name;
        const string        _group;
        const string        _symbol;
        IBond[]             _bonds;              // List of bond Id
        double              _x;
        double              _y;
        double              _z;
        const float         _electronegativity;  // 0 if no data
        const float         _vanDerWaalsRadius;  // 0 if no data
        const float         _atomicRadius;       // 0 if no data
        const float         _covalentRadius;     // 0 id no data

        /**
         * initElectronCloud
         * It is an internal method use for put electron to each level
         * k => 1²*2 = 2
         * l => 2²*2 = 8
         * l => 2²*2 = 8
         * m => 3²*2 = 18
         * n => 4²*2 = 32
         * o => 5²*2 = 50
         * p => 6²*2 = 72
         * q => 7²*2 = 98
         */
        void initElectronCloud(){
            if ( _atomicNumber > 0 &&  _atomicNumber <= 2){
                _electronCloud['k'].length   = _atomicNumber;
                foreach(ref element; _electronCloud['k'])
                    element = new Electron();
            }
            else if ( _atomicNumber > 2 &&  _atomicNumber <= 10){
                _electronCloud['k'].length   = 2;
                foreach(ref element; _electronCloud['k'])
                    element = new Electron();
                electronCloud['l'].length   = _atomicNumber - 2;
                foreach(ref element; _electronCloud['l'])
                    element = new Electron();
            }
            else if ( _atomicNumber > 10  &&  _atomicNumber <= 28){
                electronCloud['k'].length   = 2;
                foreach(ref element; _electronCloud['k'])
                    element = new Electron();
                electronCloud['l'].length   = 8;
                foreach(ref element; _electronCloud['l'])
                    element = new Electron();
                electronCloud['m'].length   = _atomicNumber - 10;
                foreach(ref element; _electronCloud['m'])
                    element = new Electron();
            }
            else if ( _atomicNumber > 28 &&  _atomicNumber <= 60){
                electronCloud['k'].length   = 2;
                foreach(ref element; _electronCloud['k'])
                    element = new Electron();
                electronCloud['l'].length   = 8;
                foreach(ref element; _electronCloud['l'])
                    element = new Electron();
                electronCloud['m'].length   = 18;
                foreach(ref element; _electronCloud['m'])
                    element = new Electron();
                electronCloud['n'].length   = _atomicNumber - 28;
                foreach(ref element; _electronCloud['n'])
                    element = new Electron();
            }
            else if ( _atomicNumber > 60 &&  _atomicNumber <= 110){
                electronCloud['k'].length   = 2;
                foreach(ref element; _electronCloud['k'])
                    element = new Electron();
                electronCloud['l'].length   = 8;
                foreach(ref element; _electronCloud['l'])
                    element = new Electron();
                electronCloud['m'].length   = 18;
                foreach(ref element; _electronCloud['m'])
                    element = new Electron();
                electronCloud['n'].length   = 32;
                foreach(ref element; _electronCloud['n'])
                    element = new Electron();
                electronCloud['o'].length   = _atomicNumber - 60;
                foreach(ref element; _electronCloud['o'])
                    element = new Electron();
            }
            else if ( _atomicNumber > 110 &&  _atomicNumber <= 182){
                electronCloud['k'].length   = 2;
                foreach(ref element; _electronCloud['k'])
                    element = new Electron();
                electronCloud['l'].length   = 8;
                foreach(ref element; _electronCloud['l'])
                    element = new Electron();
                electronCloud['m'].length   = 18;
                foreach(ref element; _electronCloud['m'])
                    element = new Electron();
                electronCloud['n'].length   = 32;
                foreach(ref element; _electronCloud['n'])
                    element = new Electron();
                electronCloud['o'].length   = 50;
                foreach(element; _electronCloud['o'])
                    element = new Electron();
                electronCloud['p'].length   = _atomicNumber - 110;
                foreach(ref element; _electronCloud['p'])
                    element = new Electron();
            }
            else if ( _atomicNumber > 182 && _atomicNumber <= 280 ){
                electronCloud['k'].length   = 2;
                foreach(ref element; _electronCloud['k'])
                    element = new Electron();
                electronCloud['l'].length   = 8;
                foreach(ref element; _electronCloud['l'])
                    element = new Electron();
                electronCloud['m'].length   = 18;
                foreach(ref element; _electronCloud['m'])
                    element = new Electron();
                electronCloud['n'].length   = 32;
                foreach(ref element; _electronCloud['n'])
                    element = new Electron();
                electronCloud['o'].length   = 50;
                foreach(ref element; _electronCloud['o'])
                    element = new Electron();
                electronCloud['p'].length   = 72;
                foreach(ref element; _electronCloud['p'])
                    element = new Electron();
                electronCloud['q'].length   = _atomicNumber - 182;
                foreach(ref element; _electronCloud['q'])
                    element = new Electron();
            }
            else
                throw new ElectronNumberException(__FILE__, __LINE__);
        }

    public:
        this(uint atomicNumber, uint massNumber, string name, string symbol, string group, float electronegativity, float vanDerWaalsRadius, float atomicRadius, float covalentRadius){
            _atomicNumber       = atomicNumber;
            _massNumber         = massNumber;
            _protons            = new Proton[atomicNumber];
            _neutrons           = new Neutron[massNumber-atomicNumber];
            _name               = name;
            _group              = group;
            _symbol             = symbol;
            _electronegativity  = electronegativity;    // Pauling unit
            _vanDerWaalsRadius  = vanDerWaalsRadius;    // nanometer
            _atomicRadius       = atomicRadius;         // nanometer
            _covalentRadius     = covalentRadius;       // nanometer
            _x                  = double.nan;
            _y                  = double.nan;
            _z                  = double.nan;
            _atomId             = _numberOfAtom;
            _bonds              = new IBond[](0);
            _numberOfAtom++;
            initElectronCloud();
        }

        this(uint atomicNumber, uint massNumber, string name, string symbol, string group, float electronegativity, float vanDerWaalsRadius, float atomicRadius, float covalentRadius, double x, double y, double z){
            _atomicNumber       = atomicNumber;
            _massNumber         = massNumber;
            _protons            = new Proton[atomicNumber];
            _neutrons           = new Neutron[massNumber-atomicNumber];
            _name               = name;
            _group              = group;
            _symbol             = symbol;
            _electronegativity  = electronegativity;    // Pauling unit
            _vanDerWaalsRadius  = vanDerWaalsRadius;    // nanometer
            _atomicRadius       = atomicRadius;         // nanometer
            _covalentRadius     = covalentRadius;       // nanometer
            _x                  = x;
            _y                  = y;
            _z                  = z;
            _atomId             = _numberOfAtom;
            _bonds              = new IBond[](0);
            _numberOfAtom++;
            initElectronCloud();
        }

        /**
         * Copy an atom but do not has same id
         */
        this(IAtom atom){
            _atomicNumber       = atom.atomicNumber();
            _massNumber         = atom.massNumber();
            _protons            = atom.protonList();
            _neutrons           = atom.neutronList();
            _electronCloud      = atom.electronCloud();
            _name               = atom.name();
            _group              = atom.group();
            _symbol             = atom.symbol();
            _x                  = atom.x();
            _y                  = atom.y();
            _z                  = atom.z();
            _electronegativity  = atom.electronegativity();
            _vanDerWaalsRadius  = atom.vanDerWaalsRadius();
            _atomicRadius       = atom.atomicRadius();
            _covalentRadius     = atom.covalentRadius();
            _atomId             = _numberOfAtom;
            _bonds              = new IBond[](0);
            _numberOfAtom++;
            initElectronCloud();
        }

        void location(double valueX, double valueY, double valueZ){
            _x = valueX;
            _y = valueY;
            _z = valueZ;
        }

        void moveTo(double[] location){
            _x = location[0];
            _y = location[1];
            _z = location[2];
        }

        bool containBond(size_t idBond){
            bool isSearching= true;
            bool isBound    = false;
            size_t index    = 0;
            while(isSearching){
                if(index == bonds.length)
                    isSearching = false;
                else{
                    if(bonds[index].bondId == idBond){
                        isSearching = false;
                        isBound     = true;
                    }
                    else
                        index++;
                }
            }
            return isBound;
        }

        void addBond(IBond bond){
            _bonds.length= _bonds.length + 1;
            _bonds[$-1]  = bond;
        }

        void removeBond(IBond bond){
            bool isSearching = true;
            size_t index = 0;
            while (isSearching){
                if(index == _bonds.length){
                    isSearching = false;
                    throw new BondNotFoundException(bond, __FILE__, __LINE__);
                }
                else if(bond is bonds[index]){
                    if(index < _bonds.length - 1)
                        _bonds[index..$-1] = _bonds[index+1..$];
                    _bonds.length = _bonds.length - 1;
                }
            }
        }

        void removeAllBonds(){
            _bonds = new IBond[](0);
        }

        /**
         * Returns:
         * 0 if atom is in index array 0
         * 1 if atom is in index array 1
         * -1 if atom are not here
         */
        int isLinkWith(size_t id){
            bool        isSearching = true;
            int         result      = -1;
            size_t index    = 0;
            while(isSearching){
                if(index == bonds.length)
                    isSearching = false;
                else{
                    int tmp = bonds[index].isLinkWith(id);
                    if(tmp != -1){
                        isSearching = false;
                        result      = tmp;
                    }
                    else
                        index++;
                }
            }
            return result;
        }

        IAtom[] linkedWith(){
            IAtom[] atomsList = new IAtom[](0);
            foreach(bond; bonds){
                IAtom[] tmp = bond.atoms;
                if(this is tmp[0])
                    atomsList ~=tmp[1];
                else
                    atomsList ~=tmp[0];
            }
            return atomsList;
        }
        @property:

            uint atomicNumber(){
                return _atomicNumber;
            }

            uint massNumber(){
                return _massNumber;
            }

            ref Proton[] protonList(){
                return _protons;
            }

            ref Neutron[] neutronList(){
                return _neutrons;
            }

            ref Electron[][char] electronCloud(){
                //~ Electron[][char] result;
                //~ foreach (k, v; electronCloud)
                    //~ result[k] = v;
                //~ return result;
                return _electronCloud;
            }

            float electronegativity(){
                return _electronegativity;
            }

            float vanDerWaalsRadius(){
                return _vanDerWaalsRadius;
            }

            float atomicRadius(){
                return _atomicRadius;
            }

            float covalentRadius(){
                return _covalentRadius;
            }

            string name(){
                return _name.idup;
            }

            string symbol(){
                return _symbol.idup;
            }

            string group(){
                return _group.idup;
            }

            size_t atomId(){
                return _atomId;
            }

            IBond[] bonds(){
                return _bonds.dup;
            }

            double x(){
                return _x;
            }

            void x(double value){
                _x = value;
            }

            double y(){
                return _y;
            }

            void y(double value){
                _y = value;
            }

            double z(){
                return _z;
            }

            void z(double value){
                _z = value;
            }

            double[] location(){
                double[] currentLocation;
                if(isNaN(_x) || isNaN(_y) || isNaN(_z))
                    currentLocation = null;
                else
                    currentLocation = [_x, _y, _z];
                return currentLocation;
            }

            double electricCharge(){
                double electricCharge = 0;
                foreach(proton; _protons){
                    electricCharge += proton.electricCharge;
                }
                foreach(neutron; _neutrons){
                    electricCharge += neutron.electricCharge;
                }
                foreach(electron; _electronCloud['k']){
                    electricCharge += electron.electricCharge;
                }
                foreach(electron; _electronCloud['l']){
                    electricCharge += electron.electricCharge;
                }
                foreach(electron; _electronCloud['m']){
                    electricCharge += electron.electricCharge;
                }
                foreach(electron; _electronCloud['n']){
                    electricCharge += electron.electricCharge;
                }
                foreach(electron; _electronCloud['o']){
                    electricCharge += electron.electricCharge;
                }
                foreach(electron; _electronCloud['p']){
                    electricCharge += electron.electricCharge;
                }
                foreach(electron; _electronCloud['q']){
                    electricCharge += electron.electricCharge;
                }
                return electricCharge;
            }

            double mass(){
                double mass = 0;
                foreach(proton; _protons)
                    mass += proton.mass;
                foreach(neutron; _neutrons)
                    mass += neutron.mass;
                foreach(electron; _electronCloud['k'])
                    mass += electron.electricCharge;
                foreach(electron; _electronCloud['l'])
                    mass += electron.electricCharge;
                foreach(electron; _electronCloud['m'])
                    mass += electron.electricCharge;
                foreach(electron; _electronCloud['n'])
                    mass += electron.electricCharge;
                foreach(electron; _electronCloud['o'])
                    mass += electron.electricCharge;
                foreach(electron; _electronCloud['p'])
                    mass += electron.electricCharge;
                foreach(electron; _electronCloud['q'])
                    mass += electron.electricCharge;
                return mass;
            }

            size_t maxElectronInLastLevel(){
                size_t electronAvaillable = 0;
                if ('q' in _electronCloud){
                    electronAvaillable = _electronCloud['q'].length;
                }
                else if ('p' in _electronCloud){
                    electronAvaillable = _electronCloud['p'].length;
                }
                else if ('o' in _electronCloud){
                    electronAvaillable = _electronCloud['o'].length;
                }
                else if ('n' in _electronCloud){
                    electronAvaillable = _electronCloud['n'].length;
                }
                else if ('m' in _electronCloud){
                    electronAvaillable = _electronCloud['m'].length;
                }
                else if ('l' in _electronCloud){
                    electronAvaillable = _electronCloud['l'].length;
                }
                else if ('k' in _electronCloud){
                    electronAvaillable = _electronCloud['k'].length;
                }
                else if ('p' in _electronCloud){
                    electronAvaillable = _electronCloud['p'].length;
                }
                else
                    throw new ElectronCloudException(__FILE__, __LINE__);
                return electronAvaillable;
            }

            size_t numberOfBond(){
                return _bonds.length;
            }


}


IAtom atomFactory(string atomName){
    Atom atom = null;
    switch(atomName){
        case "actinium":
        case "Ac":
            atom = new Atom(89u, 227u, "actinium", "Ac", "Actinides", 1.1f, 0.0f, 0.195f, 0.215f);
            break;

        case "aluminium":
        case "Al":
            atom = new Atom(13u, 27u, "aluminium", "Al", "Other metals", 1.61f, 0.184f, 0.143f, 0.121f);
            break;

        case "americium":
        case "Am":
            atom = new Atom(95u, 241u, "americium", "Am", "Actinides", 1.3f, 0.0f, 0.173f, 0.180f);
            break;

        case "antimony":
        case "Sb":
            atom = new Atom(51u, 122u, "antimony", "Sb", "Metalloids", 2.05f, 0.206f, 0.140f, 0.139f);
            break;

        case "argon":
        case "Ar":
            atom = new Atom(18u, 40u, "argon", "Ar", "Noble gases", 0.0f, 0.188f, 0.0f, 0.106f);
            break;

        case "arsenic":
        case "As":
            atom = new Atom(33u, 75u, "arsenic", "As", "Metalloids", 2.18f, 0.185f, 0.119f, 0.119f);
            break;

        case "astatine":
        case "At":
            atom = new Atom(85u, 210u, "astatine", "At", "Halogens", 2.2f, 0.202f, 0.0f, 0.150f);
            break;

        case "barium":
        case "Ba":
            atom = new Atom(56u, 137u, "barium", "Ba", "Alkaline earth metals", 0.89f, 0.268f, 0.222f, 0.215f);
            break;

        case "berkelium":
        case "Bk":
            atom = new Atom(97u, 147u, "berkelium", "Bk", "Actinides", 1.3f, 0.0f, 0.170f, 0.0f);
            break;

        case "beryllium":
        case "Be":
            atom = new Atom(4u, 9u, "beryllium", "Be", "Alkaline earth metals", 1.57f, 0.153f, 0.105f, 0.096f);
            break;

        case "bismuth":
        case "Bi":
            atom = new Atom(83u, 209u, "bismuth", "Bi", "Other metals", 2.02f, 0.207f, 0.156f, 0.148f);
            break;

        case "bohrium":
        case "Bh":
            atom = new Atom(107u, 270u, "bohrium", "Bh", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "boron":
        case "B":
            atom = new Atom(5u, 11u, "boron", "B", "Metalloids", 2.04f, 0.192f, 0.090f, 0.084f);
            break;

        case "bromine":
        case "Br":
            atom = new Atom(35u, 80u, "bromine", "Br", "Halogens", 2.96f, 0.185f, 0.120f, 0.120f);
            break;

        case "cadmium":
        case "Cd":
            atom = new Atom(48u, 112u, "cadmium", "Cd", "Transition elements", 1.69f, 0.158f, 0.151f, 0.144f);
            break;

        case "caesium":
        case "Cs":
            atom = new Atom(55u, 133u, "caesium", "Cs", "Alkali metals", 0.79f, 0.343f, 0.265f, 0.244f);
            break;

        case "calcium":
        case "Ca":
            atom = new Atom(20u, 40u, "calcium", "Ca", "Alkaline earth metals", 1.0f, 0.231f, 0.197f, 0.176f);
            break;

        case "californium":
        case "Cf":
            atom = new Atom(98u, 251u, "californium", "Cf", "Actinides", 1.3f, 0.0f, 0.0f, 0.0f);
            break;

        case "carbon":
        case "C":
            atom = new Atom(6u, 12u, "carbon", "C", "nonmetals", 2.55f, 0.170f, 0.0f, 0.073f);
            break;

        case "cerium":
        case "Ce":
            atom = new Atom(58u, 140u, "cerium", "Ce", "Lanthanides", 1.12f, 0.0f, 0.185f, 0.204f);
            break;

        case "chlorine":
        case "Cl":
            atom = new Atom(17u, 35u, "chlorine", "Cl", "Halogens", 3.16f, 0.175f, 0.0f, 0.102f);
            break;

        case "chromium":
        case "Cr":
            atom = new Atom(24u, 52u, "chromium", "Cr", "Transition elements", 1.66f, 0.0f, 0.128f, 0.139f);
            break;

        case "cobalt":
        case "Co":
            atom = new Atom(27u, 59u, "cobalt", "Co", "Transition elements", 1.88f, 0.0f, 0.125f, 0.126f);
            break;

        case "copernicium":
        case "Cn":
            atom = new Atom(112u, 285u, "copernicium", "Cn", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "copper":
        case "Cu":
            atom = new Atom(29u, 64u, "copper", "Cu", "Transition elements", 1.90f, 0.140f, 0.128f, 0.132f);
            break;

        case "curium":
        case "Cm":
            atom = new Atom(96u, 247u, "curium", "Cm", "Actinides", 1.3f, 0.0f, 0.174f, 0.169f);
            break;

        case "darmstadtium":
        case "Ds":
            atom = new Atom(110u, 281u, "darmstadtium", "Ds", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "dubnium":
        case "Db":
            atom = new Atom(105u, 268u, "dubnium", "Db", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "dysprosium":
        case "Dy":
            atom = new Atom(66u, 163u, "dysprosium", "Dy", "Lanthanides", 1.22f, 0.0f, 0.178f, 0.192f);
            break;

        case "einsteinium":
        case "Es":
            atom = new Atom(99u, 252u, "einsteinium", "Es", "Actinides", 1.3f, 0.0f, 0.0f, 0.0f);
            break;

        case "erbium":
        case "Er":
            atom = new Atom(68u, 167u, "erbium", "Er", "Lanthanides", 1.24f, 0.0f, 0.176f, 0.189f);
            break;

        case "europium":
        case "Eu":
            atom = new Atom(63u, 152u, "europium", "Eu", "Lanthanides", 1.2f, 0.0f, 0.180f, 0.198f);
            break;

        case "fermium":
        case "Fm":
            atom = new Atom(100u, 257u, "fermium", "Fm", "Actinides", 1.3f, 0.0f, 0.0f, 0.0f);
            break;

        case "fluorine":
        case "F":
            atom = new Atom(9u, 19u, "fluorine", "F", "Halogens", 3.98f, 0.147f, 0.0f, 0.057f);
            break;

        case "francium":
        case "Fr":
            atom = new Atom(87u, 223u, "francium", "Fr", "Alkali metals", 0.7f, 0.348f, 0.0f, 0.260f);
            break;

        case "gadolinium":
        case "Gd":
            atom = new Atom(64u, 157u, "gadolinium", "Gd", "Lanthanides", 1.2f, 0.0f, 0.180f, 0.196f);
            break;

        case "gallium":
        case "Ga":
            atom = new Atom(31u, 70u, "gallium", "Ga", "Other metals", 1.81f, 0.187f, 0.135f, 0.122f);
            break;

        case "germanium":
        case "Ge":
            atom = new Atom(32u, 73u, "germanium", "Ge", "Metalloids", 2.01f, 0.211f, 0.122f, 0.122f);
            break;

        case "gold":
        case "Au":
            atom = new Atom(79u, 197u, "gold", "Au", "Transition elements", 2.54f, 0.166f, 0.144f, 0.136f);
            break;

        case "hafnium":
        case "Hf":
            atom = new Atom(72u, 179u, "hafnium", "Hf", "Transition elements", 1.3f, 0.0f, 0.159f, 0.175f);
            break;

        case "hassium":
        case "Hs":
            atom = new Atom(108u, 269u, "hassium", "Hs", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "helium":
        case "He":
            atom = new Atom(2u, 4u, "helium", "He", "Noble gases", 0.0f, 0.140f, 0.118f, 0.032f);
            break;

        case "holmium":
        case "Ho":
            atom = new Atom(67u, 165u, "holmium", "Ho", "Lanthanides", 1.23f,  0.0f, 0.176f, 0.192f);
            break;

        case "hydrogen":
        case "H":
            atom = new Atom(1u, 1u, "hydrogen", "H", "nonmetals", 2.2f, 0.120f, 0.125f, 0.037f);
            break;

        case "indium":
        case "In":
            atom = new Atom(49u, 115u, "indium", "In", "Other metals", 1.78f, 0.193f, 0.167f, 0.144f);
            break;

        case "iodine":
        case "I":
            atom = new Atom(53u, 127u, "iodine", "I", "halogens", 2.66f, 0.198f, 0.140f, 0.133f);
            break;

        case "iridium":
        case "Ir":
            atom = new Atom(77u, 192u, "iridium", "Ir", "Transition elements", 2.20f, 0.0f, 0.136f, 0.137f);
            break;

        case "iron":
        case "Fe":
            atom = new Atom(26u, 56u, "iron", "Fe", "Transition elements", 1.83f, 0.0f, 0.126f, 0.125f);
            break;

        case "krypton":
        case "Kr":
            atom = new Atom(36u, 84u, "krypton", "Kr", "Noble gases", 3.00f, 0.202f, 0.0f, 0.110f );
            break;

        case "lanthanum":
        case "La":
            atom = new Atom(57u, 139u, "lanthanum", "La", "Lanthanides", 1.10f, 0.0f, 0.187f, 0.169f);
            break;

        case "lawrencium":
        case "Lr":
            atom = new Atom(103u, 262u, "lawrencium", "Lr", "Actinides", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "lead":
        case "Pb":
            atom = new Atom(82u, 207u, "lead", "Pb", "Other metals", 2.33f, 0.202f, 0.175f, 0.147f);
            break;

        case "lithium":
        case "Li":
            atom = new Atom(3u, 7u, "lithium", "Li", "Alkali metals", 0.98f, 0.182f, 0.152f, 0.134f);
            break;

        case "lutetium":
        case "Lu":
            atom = new Atom(71u, 175u, "lutetium", "Lu", "Lanthanides", 1.27f, 0.0f, 0.174f, 0.160f);
            break;

        case "magnesium":
        case "Mg":
            atom = new Atom(12u, 24u, "magnesium", "Mg", "Alkaline earth metals", 1.31f, 0.173f, 0.160f, 0.130f);
            break;

        case "manganese":
        case "Mn":
            atom = new Atom(25u, 55u, "manganese", "Mn", "Transition elements", 1.55f, 0.126f, 0.140f, 0.139f);
            break;

        case "meitnerium":
        case "Mt":
            atom = new Atom(109u, 268u, "meitnerium", "Mt", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "mendelevium":
        case "Md":
            atom = new Atom(101u, 258u, "mendelevium", "Md", "Actinides", 1.3f, 0.0f, 0.0f, 0.0f);
            break;

        case "molybdenum":
        case "Mo":
            atom = new Atom(42u, 96u, "molybdenum", "Mo", "Transition elements", 2.16f, 0.0f, 0.145f, 0.145f);
            break;

        case "neodymium":
        case "Nd":
            atom = new Atom(60u, 144u, "neodymium", "Nd", "Lanthanides", 1.14f, 0.0f, 0.181f, 0.201f);
            break;

        case "neon":
        case "Ne":
            atom = new Atom(10u, 20u, "neon", "Ne", "Noble gases", 0.0f, 0.154f, 0.0f, 0.069f);
            break;

        case "neptunium":
        case "Np":
            atom = new Atom(93u, 237u, "neptunium", "Np", "Actinides", 1.36f, 0.0f, 0.155f, 0.190f);
            break;

        case "nickel":
        case "Ni":
            atom = new Atom(28u, 59u, "nickel", "Ni", "Transition elements", 1.91f, 0.163f, 0.135f, 0.121f);
            break;

        case "niobium":
        case "Nb":
            atom = new Atom(41u, 93u, "niobium", "Nb", "Transition elements", 1.6f, 0.0f, 0.146f, 0.137f);
            break;

        case "nitrogen":
        case "N":
            atom = new Atom(7u, 14u, "nitrogen", "N", "nonmetals", 3.04f, 0.155f, 0.092f, 0.075f);
            break;

        case "nobelium":
        case "No":
            atom = new Atom(102u, 259u, "nobelium", "No", "Actinides", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "osmium":
        case "Os":
            atom = new Atom(76u, 190u, "osmium", "Os", "Transition elements", 2.2f, 0.0f, 0.135f, 0.128f);
            break;

        case "oxigen":
        case "O":
            atom = new Atom(8u, 16u, "oxigen", "O", "nonmetals", 3.44f, 0.152f, 0.066f, 0.073f);
            break;

        case "palladium":
        case "Pd":
            atom = new Atom(46u, 106u, "palladium", "Pd", "Transition elements", 2.20f, 0.163f, 0.137f, 0.131f);
            break;

        case "platinum":
        case "Pt":
            atom = new Atom(78u, 195u, "platinum", "Pt", "Transition elements", 2.28f, 0.175f, 0.139f, 0.128f);
            break;

        case "plutonium":
        case "Pu":
            atom = new Atom(94u, 244u, "plutonium", "Pu", "Actinides", 1.28f, 0.0f, 0.159f, 0.187f);
            break;

        case "polonium":
        case "Po":
            atom = new Atom(84u, 209u, "polonium", "Po", "Metalloids", 2.0f, 0.197f, 0.168f, 0.140f);
            break;

        case "potassium":
        case "K":
            atom = new Atom(19u, 39u, "potassium", "K", "Alkali metals", 0.82f, 0.275f, 0.227f, 0.196f);
            break;

        case "praseodymium":
        case "Pr":
            atom = new Atom(59u, 141u, "praseodymium", "Pr", "Lanthanides", 1.13f, 0.0f, 0.182f, 0.203f);
            break;

        case "promethium":
        case "Pm":
            atom = new Atom(61u, 145u, "promethium", "Pm", "Lanthanides", 1.13f, 0.0f, 0.183f, 0.199f);
            break;

        case "protactinium":
        case "Pa":
            atom = new Atom(91u, 231u, "protactinium", "Pa", "Actinides", 1.5f, 0.0f, 0.163f, 0.200f);
            break;

        case "radium":
        case "Ra":
            atom = new Atom(88u, 226u, "radium", "Ra", "Alkaline earth metals", 0.9f, 0.283f, 0.0f, 0.221f);
            break;

        case "radon":
        case "Rn":
            atom = new Atom(86u, 222u, "radon", "Rn", "Noble gases", 2.2f, 0.220f, 0.0f, 0.145f);
            break;

        case "rhenium":
        case "Re":
            atom = new Atom(75u, 186u, "rhenium", "Re", "Transition elements", 1.9f, 0.0f, 0.137f, 0.159f);
            break;

        case "rhodium":
        case "Rh":
            atom = new Atom(45u, 103u, "rhodium", "Rh", "Transition elements", 2.28f, 0.0f, 0.134f, 0.135f);
            break;

        case "roentgenium":
        case "Rg":
            atom = new Atom(111u, 281u, "roentgenium", "Rg", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "rubidium":
        case "Rb":
            atom = new Atom(37u, 85u, "rubidium", "Rb", "Alkali metals", 0.82f, 0.303f, 0.248f, 0.211f);
            break;

        case "ruthenium":
        case "Ru":
            atom = new Atom(44u, 101u, "ruthenium", "Ru", "Transition elements", 2.3f, 0.0f, 0.134f, 0.126f);
            break;

        case "rutherfordium":
        case "Rf":
            atom = new Atom(104u, 261u, "rutherfordium", "Rf", "Transition elements", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "samarium":
        case "Sm":
            atom = new Atom(62u, 150u, "samarium", "Sm", "Lanthanides", 1.17f, 0.0f, 0.180f, 0.198f);
            break;

        case "scandium":
        case "Sc":
            atom = new Atom(21u, 45u, "scandium", "Sc", "Transition elements", 1.36f, 0.211f, 0.162f, 0.144f);
            break;

        case "seabum":
        case "Sg":
            atom = new Atom(106u, 266u, "seabum", "Sg", "Transition elements", 1.36f, 0.211f, 0.162f, 0.170f);
            break;

        case "selenium":
        case "Se":
            atom = new Atom(34u, 79u, "selenium", "Se", "nonmetals", 2.55f, 0.190f, 0.120f, 0.116f);
            break;

        case "silicon":
        case "Si":
            atom = new Atom(14u, 28u, "silicon", "Si", "Metalloids", 1.90f, 0.210f, 0.111f, 0.111f);
            break;

        case "silver":
        case "Ag":
            atom = new Atom(47u, 108u, "silver", "Ag", "Transition elements", 1.93f, 0.172f, 0.144f, 0.153f);
            break;

        case "sodium":
        case "Na":
            atom = new Atom(11u, 23u, "sodium", "Na", "Alkali metals", 0.93f, 0.227f, 0.186f, 0.154f);
            break;

        case "strontium":
        case "Sr":
            atom = new Atom(38u, 88u, "strontium", "Sr", "Alkaline earth metals", 0.95f, 0.249f, 0.215f, 0.192f);
            break;

        case "sulfur":
        case "S":
            atom = new Atom(16u, 32u, "sulfur", "S", "nonmetals", 2.58f, 0.180f, 0.0f, 0.102f);
            break;

        case "tantalum":
        case "Ta":
            atom = new Atom(73u, 181u, "tantalum", "Ta", "Transition elements", 1.5f, 0.0f, 0.146f, 0.138f);
            break;

        case "technetium":
        case "Tc":
            atom = new Atom(43u, 98u, "technetium", "Tc", "Transition elements", 1.9f, 0.0f, 0.136f, 0.156f);
            break;

        case "tellurium":
        case "Te":
            atom = new Atom(52u, 128u, "tellurium", "Te", "Metalloids", 2.1f, 0.206f, 0.140f, 0.135f);
            break;

        case "terbium":
        case "Tb":
            atom = new Atom(65u, 159u, "terbium", "Tb", "Lanthanides", 1.2f, 0.0f, 0.177f, 0.194f);
            break;

        case "thallium":
        case "TI":
            atom = new Atom(81u, 204u, "thallium", "Ti", "Other metals", 1.62f, 0.196f, 0.170f, 0.148f);
            break;

        case "thorium":
        case "Th":
            atom = new Atom(90u, 232u, "thorium", "Th", "Actinides", 1.3f, 0.0f, 0.179f, 0.206f);
            break;

        case "thulium":
        case "Tm":
            atom = new Atom(69u, 169u, "thulium", "Tm", "Lanthanides", 1.25f, 0.0f, 0.176f, 0.190f);
            break;

        case "tin":
        case "Sn":
            atom = new Atom(50u, 119u, "tin", "Sn", "Other metals", 1.96f, 0.217f, 0.140f, 0.141f);
            break;

        case "titanium":
        case "Ti":
            atom = new Atom(22u, 48u, "titanium", "Ti", "Transition elements", 1.54f, 0.0f, 0.147f, 0.136f);
            break;

        case "tungsten":
        case "W":
            atom = new Atom(74u, 184u, "tungsten", "W", "Transition elements", 2.36f, 0.0f, 0.139f, 0.146f);
            break;

        case "ununhexium":
        case "Uuh":
            atom = new Atom(116u, 293u, "ununhexium", "Uuh", "Other metals", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "ununoctium":
        case "Uuo":
            atom = new Atom(118u, 294u, "ununoctium", "Uuo", "Unknown chemical properties", 0.0f, 0.0f, 0.152f, 0.230f);
            break;

        case "ununpentium":
        case "Uup":
            atom = new Atom(115u, 289u, "ununpentium", "Uup", "Other metals", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "ununquadium":
        case "Uuq":
            atom = new Atom(114u, 289u, "ununquadium", "Uuq", "Other metals", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "ununseptium":
        case "Uus":
            atom = new Atom(117u, 294u, "ununseptium", "Uus", "Unknown chemical properties", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "ununtrium":
        case "Uut":
            atom = new Atom(113u, 286u, "ununtrium", "Uut", "Other metals", 0.0f, 0.0f, 0.0f, 0.0f);
            break;

        case "uranium":
        case "U":
            atom = new Atom(92u, 238u, "uranium", "U", "Actinides", 1.38f, 0.186f, 0.156f, 0.196f);
            break;

        case "vanadium":
        case "V":
            atom = new Atom(23u, 51u, "vanadium", "V", "Transition elements", 1.63f, 0.0f, 0.134f, 0.125f);
            break;

        case "xenon":
        case "Xe":
            atom = new Atom(54u, 131u, "xenon", "Xe", "Noble gases", 2.6f, 0.216f, 0.0f, 0.130f);
            break;

        case "ytterbium":
        case "Yb":
            atom = new Atom(70u, 173u, "ytterbium", "Yb", "Lanthanides", 1.1f, 0.0f, 0.176f, 0.187f);
            break;

        case "yttrium":
        case "Y":
            atom = new Atom(39u, 89u, "yttrium", "Y", "Transition elements", 1.22f, 0.0f, 0.180f, 0.162f);
            break;

        case "zinc":
        case "Zn":
            atom = new Atom(30u, 65u, "zinc", "Zn", "Transition elements", 1.65f, 0.139f, 0.134f, 0.131f);
            break;

        case "zirconium":
        case "Zr":
            atom = new Atom(40u, 91u, "zirconium", "Zr", "Transition elements", 1.33f, 0.0f, 0.160f, 0.148f);
            break;

        default:
            throw new UnknowAtomException(atomName, __FILE__, __LINE__);
    }
    return atom;
}
