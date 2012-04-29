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
 * Bond definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/physic/bond.d
 */

module dscience.physic.bond;

import std.string;

import dscience.physic.atom;
import dscience.exception;


interface IBond {
    public:
        int      isLinkWith(size_t id);
        @property:
            size_t      bondId();
            string      type();
            ref IAtom[] atoms();
            uint        electronNeed();
}

class Bond : IBond{
    private:
        static size_t   _numberOfBound;
        size_t          _bondId;
        string          _type;
        uint            _typeId;
        uint            _electronNeed;
        IAtom[2]        _atoms;

        void addBondInAtom(){
            _atoms[0].addBond(this);
            _atoms[1].addBond(this);
        }

    public:
        this(string type, uint typeId, IAtom atom1, IAtom atom2){
            _type           = type;
            _typeId         = typeId;
            _electronNeed   = 2u;        // 1 for each atom
            _atoms[0..2]    = [atom1, atom2];
            _bondId         = _numberOfBound;
            _numberOfBound++;
            addBondInAtom();
        }

        this(string type, uint typeId, uint electronNeed, IAtom atom1, IAtom atom2){
            _type           = type;
            _typeId         = typeId;
            _electronNeed   = electronNeed;        // electronNeed/2 for each atom
            _atoms[0..2]    = [atom1, atom2];
            _bondId         = _numberOfBound;
            _numberOfBound++;
            addBondInAtom();
        }


        /**
         * Returns:
         * 0 if atom is in index array 0
         * 1 if atom is in index array 1
         * -1 if atom are not here
         */
        int isLinkWith(size_t id){
            return (id == _atoms[0].atomId )? 0 : (id == _atoms[1].atomId )? 1 : -1;
        }

        @property:
            size_t bondId(){
                return bondId;
            }

            string type(){
                return type.idup;
            }

            ref IAtom[] atoms(){
                return atoms;
            }

            uint electronNeed(){
                return electronNeed;
        }
}


IBond bondFactory(string bondName, IAtom atom1, IAtom atom2){
    Bond bond = null;
    switch (bondName){
        case "aromatic":
        case "Aromatic":{
            bond   = new Bond("Aromatic bond", 0u, atom1, atom2);
            break;
        }
        case "bent":
        case "Bent":{
            bond   = new Bond("Bent bond", 1u, atom1, atom2);
            break;
        }
        case "covalent":
        case "Covalent":{
            bond   = new Bond("Covalent bond", 2u, atom1, atom2);
            break;
        }
        case "halogen":
        case "Halogen":{
            bond   = new Bond("Halogen bond", 3u, atom1, atom2);
            break;
        }
        case "hydrogen":
        case "Hydrogen":{
            bond   = new Bond("Hydrogen bond", 4u, atom1, atom2);
            break;
        }
        case "ionic":
        case "Ionic":{
            bond   = new Bond("Ionic bond", 5u, atom1, atom2);
            break;
        }
        case "metallic":
        case "Metallic":{
            bond   = new Bond("Metallic bond", 6u, atom1, atom2);
            break;
        }
        case "van der waals":
        case "Van Der Waals":{
            bond   = new Bond("Van der Waals bond", 7u, atom1, atom2);
            break;
        }
        default:
            throw new UnknowBondException(__FILE__,__LINE__);
    }
    return bond;
}

IBond bondFactory(string bondName, uint electronNeed, IAtom atom1, IAtom atom2){
    Bond bond = null;
    switch (bondName){
        case "aromatic":
        case "Aromatic":{
            bond   = new Bond("Aromatic bond", 0u, electronNeed, atom1, atom2);
            break;
        }
        case "bent":
        case "Bent":{
            bond   = new Bond("Bent bond", 1u, electronNeed, atom1, atom2);
            break;
        }
        case "covalent":
        case "Covalent":{
            bond   = new Bond("Covalent bond", 2u, electronNeed, atom1, atom2);
            break;
        }
        case "halogen":
        case "Halogen":{
            bond   = new Bond("Halogen bond", 3u, electronNeed, atom1, atom2);
            break;
        }
        case "hydrogen":
        case "Hydrogen":{
            bond   = new Bond("Hydrogen bond", 4u, electronNeed, atom1, atom2);
            break;
        }
        case "ionic":
        case "Ionic":{
            bond   = new Bond("Ionic bond", 5u, electronNeed, atom1, atom2);
            break;
        }
        case "metallic":
        case "Metallic":{
            bond   = new Bond("Metallic bond", 6u, electronNeed, atom1, atom2);
            break;
        }
        case "van der waals":
        case "Van Der Waals":{
            bond   = new Bond("Van der Waals bond", 7u, electronNeed, atom1, atom2);
            break;
        }
        default:
            throw new UnknowBondException(__FILE__,__LINE__);
    }
    return bond;
}
