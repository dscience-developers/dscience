//~ module dscience.parser.Pdbml;
//~
//~ private import tango.io.device.File;
//~ private import tango.text.xml.Document;
//~ private import Unicode = tango.text.Unicode;
//~ private import Convert = tango.util.Convert : to;
//~ private import dscience.physic.atom.model.IAtom;
//~ private import dscience.core.UnknowAtomException;
//~ private import dscience.physic.molecule.model.IMolecule;
//~ private import dscience.physic.molecule.Molecule;
//~ private import dscience.physic.molecule.acid.amino.AminoFactory;
//~ private import dscience.physic.molecule.complex.Protein;
//~ private import dscience.physic.molecule.complex.model.IProtein;
//~ private import dscience.physic.bond.BondFactory;
//~ private import Text = tango.text.Util;
//~
//~ private alias Document!(char) XML;
//~
//~ public class Pdbml{
    //~ private File                    pdbml;
    //~ private XmlPath!(char).NodeSet  root;
//~
    //~ public this(char[] fileName){
        //~ this.pdbml          = new File (fileName);
        //~ // load xml document
        //~ char[]content       = cast(char[])pdbml.load;
        //~ pdbml.close;
        //~ // create document
        //~ Document!(char) doc = new Document!(char);
        //~ doc.parse(content);
        //~ this.root           = doc.query[].dup;
    //~ }
//~
    //~ public char[] getCompoundName(XML.Node compound){
        //~ auto result = compound.query.child("name");
        //~ return Unicode.toLower(result.nodes[0].value.dup);
    //~ }
//~
    //~ public char[] getProteinName(uint id){
        //~ auto    entityCategory  = root.descendant("entityCategory");
        //~ auto    entity          = entityCategory.child("entity").filter((XML.Node n){
                                                                                        //~ return Convert.to!(uint)(n.attributes.name(null, "id").value) == id;
                                                                                    //~ });
        //~ char[]  name            = entity.child("pdbx_description").nodes[0].value;
        //~ return name;
    //~ }
//~
    //~ public IMolecule[] getMolecules(uint model, uint id, char[] asym_id){
        //~ auto pdbx_poly_seq_schemeCategory  = root.descendant("pdbx_poly_seq_schemeCategory");
        //~ auto pdbx_poly_seq_scheme          = pdbx_poly_seq_schemeCategory.child("pdbx_poly_seq_scheme").filter((XML.Node n) {
                                                                                                                                //~ return n.attributes.name(null, "asym_id").value == asym_id;
                                                                                                                            //~ }).dup;
        //~ IMolecule[] molecules = new IMolecule[](pdbx_poly_seq_scheme.child.count);
//~
        //~ size_t index = 0;
        //~ foreach(molecule; pdbx_poly_seq_scheme){
            //~ char[] pdb_mon_id   = Unicode.toLower(molecule.query.child("pdb_mon_id").nodes[0].value);
            //~ uint   pdb_seq_num  = Convert.to!(uint)(molecule.query.child("pdb_seq_num").nodes[0].value);
            //~ molecules[index]    = aminoFactory(pdb_mon_id);
            //~ setCoordinateAtom(model, id, asym_id, pdb_seq_num, molecules[index]);
            //~ index++;
        //~ }
        //~ molecules.length = index;
        //~ return molecules;
    //~ }
//~
    //~ public IProtein getProtein(uint model, size_t entity_id, char[][][]peptides ...){
        //~ auto struct_ref_seqCategory  = root.descendant("struct_ref_seqCategory");
        //~ auto struct_ref_seq          = struct_ref_seqCategory.child("struct_ref_seq").dup;
        //~ IMolecule[][]   molecules       = new IMolecule[][](peptides.length);
        //~ char[]          proteinName     = getProteinName(entity_id);
//~
        //~ uint[char[]] strands;
        //~ size_t index = 0;
        //~ foreach(peptide; peptides){
            //~ foreach(chain; peptide){
                //~ char[][]    tmp     = Text.split(chain,",");
                //~ uint        id      = Convert.to!(uint)(tmp[0]);
                //~ char[]      strand  = tmp[1];
                //~ molecules[index]    = getMolecules(model, id, strand);
                //~ strands[strand]     = index;
                //~ index++;
            //~ }
        //~ }
        //~ molecules.length = index;
        //~ createDisulfideBond(molecules, strands);
        //~ IProtein protein = new Protein(proteinName, molecules);
        //~ protein.doPeptideBond();
        //~ return protein;
    //~ }
//~
    //~ public IProtein[] getProteins(uint model){
        //~ auto        entity_polyCategory = root.descendant("entity_polyCategory");
        //~ char[][][] pdbx_strand_id       = new char[][][](0);
        //~ size_t[] entity_id              = new size_t[](0);
        //~ foreach(entity_poly; entity_polyCategory.child){
            //~ entity_id ~= Convert.to!(size_t)(entity_poly.attributes.name(null, "entity_id").value);
            //~ pdbx_strand_id~= Text.split(entity_poly.query.child("pdbx_strand_id").nodes[0].value,",");
        //~ }
        //~ IProtein[]  proteins            = new IProtein[](pdbx_strand_id.length);
        //~ /**
         //~ *  entity  strand
         //~ *  [i]     [k]
         //~ *  [0]     [0] => A
         //~ *  [0]     [1] => C
         //~ *  [1]     [0] => B
         //~ *  [0]     [1] => D
         //~ * peptide1 = [0][0]+[1][0]
         //~ * peptide2 = [0][1]+[1][1]
         //~ * peptide 1 2 is same peptide ie same entity: A = C and B = D
         //~ */
        //~ for(size_t j = 0; j < pdbx_strand_id.length; j++){
            //~ size_t i = 0;
            //~ char[][][] peptides = new char[][][](entity_id.length);
            //~ // register all peptide need for protein
            //~ while( i < entity_id.length-1){
                //~ peptides[i] ~= Convert.to!(char[])(i+1)~","~pdbx_strand_id[i][j]; // ie entity 1 strand A -> 1,A
                //~ i++;
                //~ peptides[i] ~= Convert.to!(char[])(i+1)~","~pdbx_strand_id[i][j];
                //~ proteins[j]  = getProtein(model, entity_id[i], peptides);
            //~ }
            //~ i = 0;
        //~ }
        //~ return proteins;
    //~ }
//~
    //~ /**
     //~ * Return a list of chemical compound found in file
     //~ */
    //~ char[][] getChemicalCompound(){
        //~ auto        compounds   = root.descendant("chem_compCategory");
        //~ char[][]    result      = new char[][](compounds.child.count);
        //~ size_t index = 0;
        //~ foreach(compound ; compounds.child){
            //~ result[index] = getCompoundName(compound);
            //~ index++;
        //~ }
        //~ return result;
    //~ }
//~
    //~ private void setCoordinateAtom(uint model, uint id, char[] pdbx_strand_id, uint pdb_seq_num, IMolecule molecule){
        //~ auto atom_siteCategory      = root.descendant("atom_siteCategory");
        //~ auto        atoms           = atom_siteCategory.child("atom_site").filter((XML.Node n)  {
                                                                                                    //~ return Convert.to!(uint)(n.query.child("pdbx_PDB_model_num").nodes[0].value) == model && Convert.to!(uint)(n.query.child("label_entity_id").nodes[0].value) == id && n.query.child("label_asym_id").nodes[0].value == pdbx_strand_id && Convert.to!(uint)(n.query.child("label_seq_id").nodes[0].value) == pdb_seq_num && (n.query.child("label_alt_id").nodes[0].value == "" || n.query.child("label_alt_id").nodes[0].value == "A");
                                                                                                //~ }).dup;
        //~ size_t C, H, O, N, S = 0;
        //~ foreach(atom ; atoms){
            //~ double  x       = Convert.to!(double)(atom.query.child("Cartn_x").nodes[0].value);
            //~ double  y       = Convert.to!(double)(atom.query.child("Cartn_y").nodes[0].value);
            //~ double  z       = Convert.to!(double)(atom.query.child("Cartn_z").nodes[0].value);
            //~ char[]  symbol  = Convert.to!(char[])(atom.query.child("type_symbol").nodes[0].value);
            //~ switch(symbol){
                //~ case "C":
                    //~ C++;
                    //~ molecule.setAtomLocation(symbol, C, x, y, z);
                    //~ break;
                //~ case "H":
                    //~ H++;
                    //~ molecule.setAtomLocation(symbol, H, x, y, z);
                    //~ break;
                //~ case "O":
                    //~ O++;
                    //~ molecule.setAtomLocation(symbol, O, x, y, z);
                    //~ break;
                //~ case "N":
                    //~ N++;
                    //~ molecule.setAtomLocation(symbol, N, x, y, z);
                    //~ break;
                //~ case "S":
                    //~ S++;
                    //~ molecule.setAtomLocation(symbol, S, x, y, z);
                    //~ break;
                //~ default:
                    //~ throw new UnknowAtomException(symbol, __FILE__, __LINE__);
            //~ }
        //~ }
    //~ }
//~
    //~ private void createDisulfideBond(IMolecule[][] molecules, uint[char[]] strands){
        //~ auto struct_connCategory    = root.descendant("struct_connCategory");
        //~ auto struct_conn            = struct_connCategory.child("struct_conn").filter((XML.Node n)  {
                                                                                                        //~ return n.query.child("conn_type_id").nodes[0].value == "disulf" && (n.query.child("ptnr1_label_asym_id").nodes[0].value in strands && n.query.child("ptnr2_label_asym_id").nodes[0].value in strands);
                                                                                                    //~ }).dup;
        //~ foreach(molecule; struct_conn){
            //~ size_t molecule1Index       = Convert.to!(size_t)(molecule.query.child("ptnr1_label_seq_id").nodes[0].value) - 1;
            //~ size_t molecule2Index       = Convert.to!(size_t)(molecule.query.child("ptnr2_label_seq_id").nodes[0].value) - 1;
            //~ char[] ptnr1_label_asym_id  = molecule.query.child("ptnr1_label_asym_id").nodes[0].value;
            //~ char[] ptnr2_label_asym_id  = molecule.query.child("ptnr2_label_asym_id").nodes[0].value;
            //~ size_t strand1              = strands[ptnr1_label_asym_id];
            //~ size_t strand2              = strands[ptnr2_label_asym_id];
            //~ IMolecule molecule1         = molecules[strand1][molecule1Index];
            //~ IMolecule molecule2         = molecules[strand2][molecule2Index];
            //~ ICompound[] thiol1          = molecule1.getCompounds("thiol");
            //~ ICompound[] thiol2          = molecule2.getCompounds("thiol");
            //~ IAtom[] sulfur1             = thiol1[0].find("S");
            //~ IAtom[] sulfur2             = thiol2[0].find("S");
            //~ IAtom[] hydrogen1           = thiol1[0].find("H");
            //~ IAtom[] hydrogen2           = thiol2[0].find("H");
            //~ molecule1.remove(hydrogen1);
            //~ molecule2.remove(hydrogen2);
            //~ bondFactory("covalent",sulfur1[0], sulfur2[0]);
        //~ }
    //~ }
//~ }
