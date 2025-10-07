#!/bin/bash

${WGET} http://www.quantum-simulation.org/potentials/sg15_oncv/upf/Ag_ONCV_PBE_FR-1.0.upf
${WGET} http://www.quantum-simulation.org/potentials/sg15_oncv/upf/Br_ONCV_PBE_FR-1.0.upf

cat > pw.in << EOF
&control
calculation  = 'scf'
restart_mode = 'from_scratch'
pseudo_dir   = './'
outdir       = './'
prefix       = 'test'
/
&system
ibrav           = 1
celldm(1)       = 20
nat             = 2
ntyp            = 2
ecutwfc         = 25
nbnd            = 30
noncolin        = .true.
lspinorb        = .true.
assume_isolated = 'mp'
/
&electrons
diago_full_acc = .true.
/
ATOMIC_SPECIES
Ag  107.86820  Ag_ONCV_PBE_FR-1.0.upf
Br   79.90400  Br_ONCV_PBE_FR-1.0.upf
ATOMIC_POSITIONS bohr
Ag  0.0000  0.0000  0.0000
Br  4.5223  0.0000  0.0000
K_POINTS automatic
1 1 1 0 0 0
EOF


cat > wstat.in << EOF
input_west:
  qe_prefix: test
  west_prefix: test
  outdir: ./

wstat_control:
  wstat_calculation: S
  n_pdep_eigen: 50
EOF


cat > wfreq.in << EOF
input_west:
  qe_prefix: test
  west_prefix: test
  outdir: ./

wstat_control:
  wstat_calculation: S
  n_pdep_eigen: 50

wfreq_control:
  wfreq_calculation: XWGQ
  macropol_calculation: N
  n_pdep_eigen_to_use: 50
  qp_bandrange: [25,28]
EOF
