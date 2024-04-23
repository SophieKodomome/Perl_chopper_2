#!/usr/bin/perl
use strict;
use warnings;
use Tk;
use Tk::PNG;
use Tk::JPEG;
use lib '.';

use MyCon;

package Heliport;
use parent -norequire, 'Objet';

#constructeur
sub new {
    my ($class, $id) = @_;
    my $self = $class->SUPER::new(0, 0, 0, 0, "");
   $self->{win} = 0;
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

    my $resultList = MyCon->select("heliport", $arguments, $value);
    foreach my $row (@$resultList) {
        foreach my $key (keys %$row) {
            if ($key eq "x") {
                $self->setX1($row->{$key});
            } elsif ($key eq "y") {
                $self->setY1($row->{$key});
            } elsif ($key eq "images") {
                $self->setImages($row->{$key});
            } elsif ($key eq "arrive") {
                $self->{win} = $row->{$key};
            }
        }
        last;
    }
}

#liste des heliport
sub getList {
    my ($self) = @_;
    my $arguments = ["id"];
    my $resultList = MyCon->select("heliport", $arguments, "");

    my @heliports;
    foreach my $row (@$resultList) {
        my $id = $row->{id};
        my $heliport = Heliport->new($id);
        push @heliports, $heliport;
    }

    return \@heliports;
}


1;