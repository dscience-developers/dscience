private import dscience.biology.alignement.NeedlemanWunsh;
private import dscience.biology.alignement.SubstitutionMatrix;
private import dscience.biology.sequence.Sequence;
private import NucleicFactory = dscience.physic.molecule.acid.nucleic.NucleicFactory;

void main(){
    SubstitutionMatrix  sm = new SubstitutionMatrix(NucleicFactory.getList());

    Sequence seq1 = new Sequence("GTATCGA");
    Sequence seq2 = new Sequence("GAATTCAGTTA", NucleicFactory.getList());

    NeedlemanWunsh nw = new NeedlemanWunsh(sm, 1, 1, 1);
    nw.pairwiseAlignment(seq1.sequence, seq2.sequence);

}
