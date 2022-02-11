Amber ff15ipq
=============

Torsion Parameter Fitting
-------------------------

ff14ipq
~~~~~~~

The torsion parameters of the Amber ff14ipq force field were fit by matching
the relative molecular mechanical energies of a set of ~62,000 conformations of
di-, tri-, and tetrapeptides to their relative quantum mechanical energies
calculated at the MP2/cc-pvTZ level.

The fitting set included dipeptide conformations (``ACE-XXX-NME``), many of
which were obtained from the Simmerling group. These included conformations
with backbone φ and ψ angles corresponding to alpha helix and beta sheet
secondary structures, as well as comprehensive sampling of φ and ψ at 20°
intervals. In addition, conformations sampling the χ1 and χ2 side chain
dihedrals at 20° intervals were used.

The set also included tripeptide conformations (``ACE-{GLY,ALA,SER}-XXX-NME``
or ``ACE-XXX-{GLY,ALA,SER}-NME``); these sampled the backbone φ and ψ at 15°
intervals.

Finally the set included tripeptide conformations (``ACE-ALA-ALA-ALA-NME`` and
``ACE-GLY-GYL-GLY-NME``), sampling φ and ψ at 10° intervals.

ff15ipq
~~~~~~~

For ff15ipq, which includes updates to the charges and Lennard-Jones radii, an
initial set of torsions has been fit using the same ~62000 conformations used
for ff14ipq. To these were added an additional ~1500 conformations of the
``ACE-ALA-PRO-ALA-NME`` tetrapeptide obtained from Dave Cerutti.

Refinement of the torsion parameters will be carried out using an iterative
cycle: conformations will be generated using version ``i`` of the force field,
and the quantum mechanical energies of these conformations incorporated into
the fitting of version ``i+1``. If version ``i`` of favors conformations that
are unfavorable according to  the quantum model, this will be reflected in
version ``i+1``. Currently my plan is to run ~30000 conformations, split into
four iterations: 

Iteration 1
___________
- Dipeptides: 23 systems including all side chain protonation states; 250
  conformations each, except for CYM and LYN which are new additions to the
  fitting set and will include 1000 conformations
- Tetrapeptides: ALAALAALA, GLYGLYGLY, and ALAPROALA; 250 conformations each
- Di-dipeptide: CYX-CYX 1000 conformations 
- Total: 9000 conformations

Iteration 2
___________
- Tripeptides: 51 systems of form GLYXXX and XXXGLY including all side chain
  protonation states; 100-125 conformations each
- Tetrapeptides: ALAALAALA, GLYGLYGLY, and ALAPROALA; 250 conformations each
- Di-dipeptide: CYX-CYX, 250 conformations 
- Total: 6100-7275 conformations

Iteration 3
___________
- Tripeptides: 51 systems of form ALAXXX and XXXALA including all side chain
  protonation states; 100-125 conformations each
- Tetrapeptides: ALAALAALA, GLYGLYGLY, and ALAPROALA; 250 conformations each
- Di-dipeptide: CYX-CYX, 250 conformations 
- Total: 6100-7275 conformations

Iteration 4
___________
- Tripeptides: 51 systems of form SERXXX and XXXSER including all side chain
  protonation states; 100-125 conformations each
- Tetrapeptides: ALAALAALA, GLYGLYGLY, and ALAPROALA; 250 conformations each
- Di-dipeptide: CYX-CYX 250 conformations 
- Total: 6100-7275 conformations

Progress
________

A table of the completed and planned calculations follows. ALA, GLY, and SER,
which are included in tripeptides and therefore present in a much larger number
of systems, are listed separately. Systems that were part of the fitting set of
ff14ipq are listed in upper case, while new systems added for ff15ipq are
listed in lower case The first iteration of calculations is underway; systems
in italics are planned as part of this iteration, while systems in bold are
complete.

.. raw:: pdf

   PageBreak

======= =============== ======================= ======================= =============== ===================
RES     SOLO            PRE                     POST                    PRE/POST        RESTRAINED
======= =============== ======================= ======================= =============== ===================
ALA     ALAALA          ALAARG alaash           ARGALA ashala           **alaproala**
        **ALAALAALA**   alaasn ALAASP           ASNALA ASPALA
                        alacym ALACYS           cymala cysala
                        alaglh ALAGLN           glhala GLNALA
                        ALAGLU ALAGLY           GLUALA GLYALA
                        alahid ALAHIE           hidala hieala
                        alahip ALAILE           hipala ileala
                        ALALEU alalyn           leuala lynala
                        ALALYS ALAMET           lysala metala
                        ALAPHE ALAPRO           pheala proala
                        ALASER ALATHR           serala thrala
                        ALATRP ALATYR           trpala tyrala
                        ALAVAL                  valala
GLY     GLYGLY          GLYALA GLYARG           ALAGLY ARGGLY
        **GLYGLYGLY**   glyash GLYASN           ashgly ASNGLY
                        GLYASP glycym           aspgly cymgly
                        GLYCYS glyglh           CYSGLY glhgly
                        GLYGLN GLYGLU           GLNGLY GLUGLY
                        glyhid GLYHIE           hidgly HIEGLY
                        glyhip GLYILE           hipgly ILEGLY
                        GLYLEU glylyn           LEUGLY lyngly
                        GLYLYS GLYMET           lysgly metgly
                        GLYPHE GLYPRO           phegly PROGLY
                        GLYSER GLYTHR           SERGLY thrgly
                        GLYTRP GLYTYR           TRPGLY TYRGLY
                        GLYVAL                  valgly
SER     *ser*           SERALA SERARG           ALASER ARGSER                           SER_ALPHA
        serser          serash SERASN           ashser ASNSER                           SER_BACKBONE
                        SERASP sercym           ASPSER cymser                           SER_BETA
                        sercys serglh           CYSSER glhser
                        SERGLN SERGLU           GLNSER gluser
                        SERGLY serhid           GLYSER hidser
                        SERHIE serhip           hieser hipser
                        SERILE SERLEU           ileser leuser
                        serlyn serlys           lynser lysser
                        SERMET SERPHE           metser pheser
                        SERPRO serthr           proser thrser
                        sertrp SERTYR           trpser tyrser
                        serval                  valser       
======= =============== ======================= ======================= =============== ===================

.. raw:: pdf

   PageBreak

======= =========== =================== =================== =================== ===================
RES     SOLO        ALA                 GLY                 SER                 RESTRAINED
======= =========== =================== =================== =================== ===================
ARG     **ARG**     ALAARG ARGALA       GLYARG ARGGLY       SERARG ARGSER       ARG_ALPHA
                                                                                ARG_BACKBONE
ASH     **ash**     alaash ashala       glyash ashgly       serash ashser       ASH_ALPHA
                                                                                ASH_BACKBONE
                                                                                ASH_BETA
ASN     **asn**     alaasn ASNALA       GLYASN ASNGLY       SERASN ASNSER       ASN_ALPHA
                                                                                ASN_BACKBONE
                                                                                ASN_BETA

ASP     **asp**     ALAASP ASPALA       glyasp aspgly       serasp ASPSER       ASP_ALPHA
                                                                                ASP_BACKBONE
                                                                                ASP_BETA
CYM     **cym**     alacym cymala       glycym cymgly       sercym cymser
CYS     **cys**     ALACYS              GLYCYS CYSGLY       sercys CYSSER       CYS_ALPHA
                                                                                CYS_BACKBONE
                                                                                CYS_BETA
CYX     *cyxcyx*                                                                CYX_ALPHA_CHI
                                                                                CYX_ALPHA_DISULF
                                                                                CYX_CHI
                                                                                CYX_DISULF
GLH     **GLH**     alaglh glhala       glyglh glhgly       serglh glhser       GLH_ALPHA
                                                                                GLH_BACKBONE
GLN     **GLN**     ALAGLN GLNALA       GLYGLN glngly       SERGLN GLNSER       GLN_ALPHA
                                                                                GLN_BACKBONE
GLU     *GLU*       ALAGLU GLUALA       GLYGLU GLUGLY       SERGLU gluser       GLU_ALPHA
                                                                                GLU_BACKBONE
HID     **hid**     alahid hidala       glyhid hidgly       serhid hidser       HID_ALPHA
                                                                                HID_BACKBONE
                                                                                HID_BETA
HIE     **hie**     ALAHIE hieala       GLYHIE HIEGLY       SERHIE hieser       HIE_ALPHA
                                                                                HIE_BACKBONE
                                                                                HIE_BETA
HIP     **hip**     alahip hipala       glyhip hipgly       serhip hipser       HIP_ALPHA
                                                                                HIP_BACKBONE
                                                                                HIP_BETA
ILE     *ile*       ALAILE ileala       GLYILE ILEGLY       SERILE ileser       ILE_ALPHA
                                                                                ILE_BACKBONE
                                                                                ILE_BETA
LEU     *leu*       ALALEU leuala       GLYLEU LEUGLY       SERLEU leuser       LEU_ALPHA
                                                                                LEU_BACKBONE
                                                                                LEU_BETA
LYN     *lyn*       alalyn lynala       glylyn lyngly       serlyn lynser
LYS     **LYS**     ALALYS lysala       GLYLYS lysgly       serlys lysser       LYS_ALPHA
                                                                                LYS_BACKBONE
MET     *MET*       ALAMET metala       GLYMET metgly       SERMET metser       MET_ALPHA
                                                                                MET_BACKBONE
PHE     *phe*       ALAPHE pheala       GLYPHE phegly       SERPHE pheser       PHE_BACKBONE
PRO     *pro*       ALAPRO proala       GLYPRO PROGLY       SERPRO proser
                    ALAPROALA
THR     *thr*       ALATHR thrala       GLYTHR thrgly       serthr thrser       THR_ALPHA
                                                                                THR_BACKBONE
                                                                                THR_BETA
TRP     **trp**     ALATRP trpala       GLYTRP TRPGLY       sertrp trpser       TRP_ALPHA
                                                                                TRP_BACKBONE
                                                                                TRP_BETA
TYR     **tyr**     ALATYR tyrala       GLYTYR TYRGLY       SERTYR tyrser       TYR_ALPHA
                                                                                TYR_BACKBONE
                                                                                TYR_BETA
VAL     **val**     ALAVAL valala       GLYVAL valgly       serval valser       VAL_ALPHA 
                                                                                VAL_BACKBONE 
                                                                                VAL_BETA
======= =========== =================== =================== =================== ===================
