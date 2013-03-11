#!/usr/bin/perl

my @spielFeld = (
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] '],
    [' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ',' [ ] ']
);

my $computerWon = 0;
my $playerWon = 0;

sub loadGame {
    for (my $y = 0; $y < $#spielFeld+1; $y++) {
        for (my $x = 0; $x < $#{$spielFeld[1]}+1; $x++) {
            print $spielFeld[$y][$x];
        }
        print "\n";
    }
}

sub reloadScreen {
    for (my $i = 0; $i < 50; $i++) {
        print "\n";
    }

    print "##################################\n";
    print "########## Vier-Gewinnt ##########\n";
    print "##################################\n\n";
    
    &loadGame;
    print "----------------------------------\n";
    print " (1)  (2)  (3)  (4)  (5)  (6)  (7)\n";
}

sub set {
    for (my $y = $#spielFeld; $y >= 0; $y--) {
        if ($spielFeld[$y][@_[0]-1] eq " [ ] ") {
            $spielFeld[$y][@_[0]-1] = ' [O] ';
            return;
        }
    }
}

sub computer {
    print "Der Computer ist am Zug";
    $num = 0;

    do {
        $num = rand(6);
    } while (!($spielFeld[0][$num] eq " [ ] "));

    for (my $y = $#spielFeld; $y >= 0; $y--) {
        if ($spielFeld[$y][$num] eq " [ ] ") {
            $spielFeld[$y][$num] = ' [X] ';
            return;
        }
    }
}

sub lookForFourP {
    $count = 0;
    for (my $y = 0; $y < $#spielFeld+1; $y++) {
        for (my $x = 0; $x < $#{$spielFeld[$y]}+1; $x++) {
            if ($spielFeld[$y][$x] eq " [O] ") {
                $count++;
                if ($count >= 4) {
                    $playerWon = 1;
                }
            } else {
                $count = 0;
            }
        }
        $count = 0;
    }

    for (my $x = 0; $x < $#{$spielFeld[0]}+1; $x++) {
        for (my $y = 0; $y < $#spielFeld+1; $y++) {
            if ($spielFeld[$y][$x] eq " [O] ") {
                $count++;
                if ($count >= 4) {
                    $playerWon = 1;
                }
            } else {
                $count = 0;
            }
        }
        $count = 0;
    }
}

sub lookForFourC {
    $count = 0;
    for (my $y = 0; $y < $#spielFeld+1; $y++) {
        for (my $x = 0; $x < $#{$spielFeld[$y]}+1; $x++) {
            if ($spielFeld[$y][$x] eq " [X] ") {
                $count++;
                if ($count >= 4) {
                    $computerWon = 1;
                }
            } else {
                $count = 0;
            }
        }
        $count = 0;
    }

    for (my $x = 0; $x < $#{$spielFeld[0]}+1; $x++) {
        for (my $y = 0; $y < $#spielFeld+1; $y++) {
            if ($spielFeld[$y][$x] eq " [X] ") {
                $count++;
                if ($count >= 4) {
                    $computerWon = 1;
                }
            } else {
                $count = 0;
            }
        }
        $count = 0;
    }
}

$tries = 0;

while ($playerWon == 0 && $computerWon == 0 && $tries < 63) {
    &reloadScreen;
    print "Sie sind am Zug: ";
    $eingabe = <STDIN>;
    &set($eingabe);
    &reloadScreen;

    &lookForFourP;

    if ($playerWon == 0 && $computerWon == 0) {
        &computer;
        sleep 1;
    }

    &reloadScreen;

    &lookForFourC;

    $tries++;
}

if ($playerWon == 1) {
    print "Sie haben gewonnen!\n";
}

if ($computerWon == 1) {
    print "Sie haben verloren!\n";
} 

if ($tries == 63) {
    print "Unentschieden!\n";
}