#!/bin/sh

# Your working dir, which should be changed
DIR=/home/lagatita/students/QE/8.mech

for i in 0990 0995 1000 1005 1010
do

A=$(echo "scale=10; $i/1000*3.570387185" | bc);


cat << EOF > $DIR/input.relax.$i
 &control
    calculation  = 'relax'
    restart_mode = 'from_scratch'
    pseudo_dir   = './'
    outdir       = './'
    prefix = 'C'
    forc_conv_thr=1.0d-4
    etot_conv_thr=1.0d-5
    nstep=100
tstress=.true.
 /
 &system
    ibrav=0
    nat=8
    ntyp=1
    ecutwfc=60.0
    occupations = 'smearing'
    degauss=0.05
 /
 &electrons
    conv_thr = 1d-12,
    mixing_beta=0.3,
    electron_maxstep = 100
 /
&IONS
  ion_dynamics='bfgs',
  pot_extrapolation = "first_order",
 /
&CELL
   cell_dynamics = 'bfgs' ,
   cell_factor = 1.5,
   press = 0 ,
/

ATOMIC_SPECIES
C 12 C.pbe-n-rrkjus_psl.1.0.0.UPF    # CHANGE THIS LINE ACCORDING TO YOUR PP

ATOMIC_POSITIONS {crystal}
C 0.250000 0.750000 0.250000 
C 0.000000 0.000000 0.500000 
C 0.250000 0.250000 0.750000 
C 0.000000 0.500000 0.000000 
C 0.750000 0.750000 0.750000 
C 0.500000 0.000000 0.000000 
C 0.750000 0.250000 0.250000 
C 0.500000 0.500000 0.500000 


CELL_PARAMETERS {Angstrom}
$A 0.000000 0.000000
0.000000 3.573710 0.000000
0.000000 0.000000 3.573710

K_POINTS {automatic}
  8 8 8 1 1 1
EOF

# You need to change this according to your machine

mpiexec -np 16 ~/soft/qe-7.0/bin/pw.x < input.relax.$i | tee output.${i}

done

