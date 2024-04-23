#!/usr/bin/perl
package Objet;

#constructeur
sub new {
    my ($class, $x1, $y1, $x2, $y2, $images) = @_;
    my $self = {
        x1 => $x1,
        y1 => $y1,
        x2 => $x2,
        y2 => $y2,
        images => $images
    };
    bless $self, $class;
    return $self;
}

#getters
sub getX1 {
    my ($self) = @_;
    return $self->{x1};
}
sub getY1 {
    my ($self) = @_;
    return $self->{y1};
}
sub getX2 {
    my ($self) = @_;
    return $self->{x2};
}
sub getY2 {
    my ($self) = @_;
    return $self->{y2};
}
sub getImages {
    my ($self) = @_;
    return $self->{images};
}

#setters
sub setX1 {
    my ($self, $i) = @_;
    $self->{x1} = $i;
}
sub setY1 {
    my ($self, $i) = @_;
    $self->{y1} = $i;
}
sub setX2 {
    my ($self, $i) = @_;
    $self->{x2} = $i;
}
sub setY2 {
    my ($self, $i) = @_;
    $self->{y2} = $i;
}
sub setImages {
    my ($self, $i) = @_;
    $self->{images} = $i;
}

1;