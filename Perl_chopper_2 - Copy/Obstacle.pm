#!/usr/bin/perl
use strict;
use warnings;
use Tk;
use Tk::PNG;
use Tk::JPEG;
use lib '.';

use MyCon;

package Obstacle;
use parent -norequire, 'Objet';

#constructeur
sub new {
    my ($class, $id) = @_;
    my $self = $class->SUPER::new(0, 0, 0, 0, "");
    bless $self, $class;

    if (defined $id) {
        $self->getFromDatabase($id);
    }
    return $self;
}


#fonctions
#get from db
sub getFromDatabase {
    my ($self, $id) = @_;

    my $arguments = ["*"];
    my $value = " WHERE id = $id";

    my $resultList = MyCon->select("obstacle", $arguments, $value);
    foreach my $row (@$resultList) {
        foreach my $key (keys %$row) {
            if ($key eq "x") {
                $self->setX1($row->{$key});
            } elsif ($key eq "y") {
                $self->setY1($row->{$key});
            } elsif ($key eq "width") {
                $self->setX2($row->{$key});
            } elsif ($key eq "height") {
                $self->setY2($row->{$key});
            } elsif ($key eq "images") {
                $self->setImages($row->{$key});
            }
        }
        last;
    }
}

#liste des obstacle
sub getList {
    my $arguments = ["id"];
    my $resultList = MyCon->select("obstacle", $arguments, "");

    my @obstacles;
    foreach my $row (@$resultList) {
        my $id = $row->{id};
        my $obstacle = Obstacle->new($id);
        push @obstacles, $obstacle;
    }

    return \@obstacles;
}


# Fonction pour créer un rectangle avec une image d'arrière-plan
sub create_rectangle_with_background {
    my ($self, $fenetre) = @_;

    my $image = $self->{images};
    my $background_image = $fenetre->{canvas}->Photo(-file => "assets/images/$image");
    
    my $background_label = $fenetre->{canvas}->Label(-image => $background_image, -width => $self->{x2}, -height => $self->{y2});
    $background_label->place(-x => $self->{x1}, -y => $self->{y1});

    my $rectangle = $fenetre->{canvas}->createRectangle(
        $self->{x1}, $self->{y1}, $self->{x1} + $self->{x2}, $self->{y1} + $self->{y2},
        -fill => undef,  # Pas de couleur de remplissage
        -outline => undef,  # Pas de contour
        -tags => 'rectangle_with_background'
    );

    return ($background_label, $rectangle);
}

1;