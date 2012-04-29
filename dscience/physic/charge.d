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
 * Charge definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/physic/charge.d
 */

module dscience.physic.charge;


class Coulomb{
    private:
        double _quantity;

    public:
        static const char symbol = 'C';
        this(){
            _quantity = 1;
        }

        this(double quantity){
            _quantity = quantity;
        }

        this(ElementaryCharge e){
            this = e.toCoulomb;
        }

        this(Coulomb c){
            _quantity = c.quantity;
        }

        ElementaryCharge toElementaryCharge(){
            return new ElementaryCharge(_quantity * 62.415096471204e18);
        }

        @property:
            double quantity(){
                return _quantity;
            }
}

class ElementaryCharge{
    private double _quantity;

    public:
    static const char symbol = 'e';
    this(){
        _quantity = 1;
    }

    this(double quantity){
        _quantity = quantity;
    }

    this(Coulomb c){
        this = c.toElementaryCharge();
    }

    this(ElementaryCharge e){
        _quantity = e.quantity;
    }

    @property double quantity(){
        return _quantity;
    }

    Coulomb toCoulomb(){
        return new Coulomb(quantity * 16.02176487e-19);
    }
}
