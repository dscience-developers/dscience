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
 * Exception raise in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/exception.d
 */

module dscience.exception;

import std.exception;
import std.string;
import dscience.physic.atom;
import dscience.physic.bond;

class AtomBondException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Two many bond used for an atom", file, line );
    }

    this(IAtom atom, string file = __FILE__, size_t line = __LINE__ ){
        string msg                  =  "Two many bond used for atom id: %sSymbol: %s\t max bond: %s".format(
            atom.atomId(),
            atom.symbol(),
            atom.maxElectronInLastLevel()
        );
        super( msg, file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( msg, file, line );
    }
}

class AtomNotFoundException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ) {
        super( "Atom not found!", file, line );
    }

    this( IAtom atom, string file = __FILE__, size_t line = __LINE__ ){
        string msg                  = "Atom id %d not found!".format( atom.atomId() );
        super( msg, file, line );
    }

    this( string type, size_t atomNum, string file = __FILE__, size_t line = __LINE__ ){
        string msg                  = "Atom type %s number %d not found!".format( type, atomNum);
        super( msg, file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( msg, file, line );
    }
}

class BadSymbolException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "One or more bad symbol!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "One or more bad symbol!"~msg, file, line );
    }
}

class BondNotFoundException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ) {
        super( "Bond not found!", file, line );
    }

    this( IBond bond, string file = __FILE__, size_t line = __LINE__ ){
        string msg                  = "Bond id %d not found!".format( bond.bondId );
        super( msg, file, line );
    }

    this( string type, size_t bondNum, string file = __FILE__, size_t line = __LINE__ ){
        string msg                  = "Bond type %s number %d not found!".format( type, bondNum );
        super( msg, file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( msg, file, line );
    }
}

class ElectronCloudException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "No electron cloud found", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( msg, file, line );
    }
}

class ElectronNumberException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ )
    {
        super( "the number of electron in an atom need be between 1 and 280", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ )
    {
        super( msg, file, line );
    }
}

class SequenceTooBigException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Sequence length is more than %d character!".format( size_t.max), file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Sequence length is more than %d character!%s".format( size_t.max, msg), file, line );
    }
}

class SymbolNotFoundException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Symbol not found!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Symbol not found: "~msg, file, line );
    }
}

class UnknowAminoAcidException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow amino acid check name or symbol!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow amino acid: "~msg, file, line );
    }
}

class UnknowAtomException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow atom check name or symbol!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow atom: "~msg, file, line );
    }
}

class UnknowBondException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow bond check name or symbol!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow bond check : "~msg, file, line );
    }
}

class UnknowMoleculeException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow molecule check name or symbol!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow molecule : "~msg, file, line );
    }
}

class UnknowCompoundException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow compound check name or symbol!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow compound : "~msg, file, line );
    }
}

class UnknowNucleicAcidException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow nucleic acid check name or symbol!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ ){
        super( "Unknow nucleic acid : "~msg, file, line );
    }
}

class UnknowSaccharideException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ )
    {
        super( "Unknow saccharide check name!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ )
    {
        super( "Unknow saccharide: "~msg, file, line );
    }
}

class UnknowMatrixException : Exception{
    this( string file = __FILE__, size_t line = __LINE__ )
    {
        super( "Unknow matrix check name!", file, line );
    }

    this( string msg, string file = __FILE__, size_t line = __LINE__ )
    {
        super( "Unknow matrix: "~msg, file, line );
    }
}
