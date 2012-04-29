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
 * Fermion definition in dscience.
 *
 * Copyright: Copyright Jonathan MERCIER  2012-.
 *
 * License:   LGPLv3+
 *
 * Authors:   Jonathan MERCIER aka bioinfornatics
 *
 * Source: dscience/physic/fermion.d
 */

module dscience.physic.fermion.d;

import dscience.physic.charge;

// baryon

class Neutron{
    private:
        Nucleon _nucleon;
        double  _mass; // Kg

    public:
        this(){
            _nucleon= new Nucleon(1,2);
            _mass   = 16.75e-27;
        }

        @property:
            double electricCharge(){
                return _nucleon.electricCharge;
            }

            double mass(){
                return _mass;
            }
}

class Nucleon{
    private:
        QuarkUp[]   _quarkUp;
        QuarkDown[] _quarkDown;

    public:
        this(size_t quarkUp, size_t quarkDown){
            _quarkUp    = new QuarkUp[quarkUp];
            _quarkDown  = new QuarkDown[quarkDown];
        }

        @property:
            double electricCharge(){
                double electricCharge = 0;
                foreach( quark; _quarkUp ){
                    electricCharge += quark.electricCharge;
                }
                foreach( quark; _quarkDown ){
                    electricCharge += quark.electricCharge;
                }
                return electricCharge;
            }

}

class Proton{
    private:
        Nucleon _nucleon;
        double  _mass; //Kg

    public:
        this(){
            _nucleon= new Nucleon(2,1);
            _mass   = 16.73e-27;
        }

        @property:
            double electricCharge(){
                return _nucleon.electricCharge;
            }

            double mass(){
                return _mass;
            }
}

// lepton
class Electron{
    private:
    ElementaryCharge    _electricCharge;
    double              _mass; //Kg

    public:
        this(){
            _electricCharge = new ElementaryCharge(-1);
            _mass   = 91.09e-31;
        }

        @property:
            double electricCharge(){
                return _electricCharge.quantity;
            }

            double mass(){
                return _mass;
            }
}

//quark
class QuarkUp{
    private ElementaryCharge _electricCharge;

    public:
        this(){
            _electricCharge = new ElementaryCharge(cast(double)2/3);
        }

    @property double electricCharge(){
        return _electricCharge.quantity;
    }
}

class QuarkDown{
    private ElementaryCharge _electricCharge;

    public:
        this(){
            _electricCharge = new ElementaryCharge(cast(double)-1/3);
        }

        @property double electricCharge(){
            return _electricCharge.quantity;
        }
}
