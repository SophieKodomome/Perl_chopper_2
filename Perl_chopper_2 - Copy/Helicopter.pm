#!/usr/bin/perl
use strict;
use warnings;
use lib '.';

use Fenetre_jeu;

package Helicopter;
use parent -norequire, 'Objet';
use Heliport;

#constructeur
sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new(0, 0, 0, 0, "Helicopter.png");
    bless $self, $class;
    return $self;
}

sub move {
    my ($self, $move_right, $move_left, $move_up, $obstacles_ref) = @_;
    
    my @obstacles = @$obstacles_ref;
    
    if ($move_right && !$self->check_collision("right", \@obstacles) && $self->{x2} < 800) {
        $self->{x1} += 10;
        $self->{x2} += 10;
    }
    if ($move_left && !$self->check_collision("left", \@obstacles) && $self->{x1} > 0) {
        $self->{x1} -= 10;
        $self->{x2} -= 10;
    }
    if ($move_up && !$self->check_collision("up", \@obstacles) && $self->{y1} > 0) {
        $self->{y1} -= 5;
        $self->{y2} -= 5;
    }
    elsif ($self->{y2} >= 800) {
        return 0;
    }
    else {
        if(!$self->check_collision("down", \@obstacles)){
            $self->{y1} += 10;
            $self->{y2} += 10;
        } else {
            return 1 if $self->check_collision("down", \@obstacles) == 2;
        }
    }

    return 0;
}

sub check_collision {
    my ($self, $direction, $obstacles_ref) = @_;

    my @obstacles = @$obstacles_ref;

    foreach my $obs (@obstacles) {
        my ($ox1, $oy1, $width, $height, $arrive) = @$obs;

        if ($direction eq "right") {
            # Collision à droite
            if ($self->{x2} >= $ox1 && $self->{x2} < $ox1 + $width && $self->{y1} < $oy1 + $height && $self->{y2} > $oy1) {
                return 1;
            }
        }
        elsif ($direction eq "left") {
            # Collision à gauche
            if ($self->{x1} <= $ox1 + $width && $self->{x1} > $ox1 && $self->{y1} < $oy1 + $height && $self->{y2} > $oy1) {
                return 1;
            }
        }
        elsif ($direction eq "down") {
            # Collision en bas
            if ($self->{y2} >= $oy1 && $self->{y2} < $oy1 + 10 && $self->{x1} < $ox1 + $width && $self->{x2} > $ox1) {
                return 2 if $arrive;
                return 1;
            }
        }
        elsif ($direction eq "up") {
            # Collision en haut
            if ($self->{y1} <= $oy1 + $height && $self->{y1} > $oy1 + $height -10 && $self->{x1} < $ox1 + $width && $self->{x2} > $ox1) {

                return 1;
            }
        }

        if ($self->{x1} < $ox1 + $width && $self->{x2} > $ox1) {
            if ($self->{y2} >= $oy1-($self->{y2}*2) && $self->{y2} < $oy1 + 10) {
                print ("scored 4\n");

            }
            elsif($self->{y2} > $oy1-($self->{y2}*3) && $self->{y2} < $oy1 + 10){
                print ("scored 2\n");
            }
        }

    }

    return 0;
}


1;