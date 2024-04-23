#!/usr/bin/perl
package Fenetre_jeu;
use strict;
use warnings;
use Tk;
use Tk::PNG;
use Tk::JPEG;
use lib '.';

use Objet;
use Helicopter;
use Obstacle;
use Heliport;
use Fenetre_menu;

sub new {
    my ($class) = @_;
    my $self = {
        mw => MainWindow->new,
        canvas => undef,
        text => undef,
        rectangle => undef,
        obstacles => undef,
        heliport => undef,
    };
    bless $self, $class;
    $self->_init;
    return $self;
}

# Declare lexical variables outside of the subroutine
my ($move_right, $move_left, $move_up) = (0, 0, 0);

sub _init {
    my ($self) = @_;
    $self->pre;

    my $Helicopter = Helicopter->new;
    my $helicopter_image = $self->draw_helicopter($Helicopter);

    $self->{obstacles}  = $self->get_obstacles;
    my @obstacles = map { [ @$_[0..3], @$_[4] ] } @{$self->{obstacles}};

    $self->{mw}->bind('<KeyPress-Right>', sub { $move_right = 1; });
    $self->{mw}->bind('<KeyRelease-Right>', sub { $move_right = 0; });
    $self->{mw}->bind('<KeyPress-Left>', sub { $move_left = 1; });
    $self->{mw}->bind('<KeyRelease-Left>', sub { $move_left = 0; });
    $self->{mw}->bind('<KeyPress-Up>', sub { $move_up = 1; });
    $self->{mw}->bind('<KeyRelease-Up>', sub { $move_up = 0; });

    $self->move_helicopter($Helicopter, $helicopter_image, \@obstacles);
}


# helicopter
sub draw_helicopter {
    my ($self, $Helicopter) = @_;

    my $image = $Helicopter->getImages(); 
    my $helicopter_image = $self->{mw}->Photo(-format => 'png', -file => "assets/images/$image");
    $Helicopter->{x2} = 50;
    $Helicopter->{y2} = 25;

    $self->{rectangle} = $self->{canvas}->createImage($Helicopter->getX1(), $Helicopter->getY1(), -image => $helicopter_image, -anchor => 'nw');

    return $helicopter_image;
}
sub move_helicopter {
    my ($self, $Helicopter, $helicopter_image, $obstacles_ref) = @_;

    my @obstacles = @$obstacles_ref; 

    if ($Helicopter->move($move_right, $move_left, $move_up, \@obstacles)) {
        my $win = $self->{mw}->Photo(-format => 'png', -file => "assets/images/win.png");
        $self->{text} = $self->{canvas}->createImage(400, 400, -image => $win);

        my $text = "Click r to restart...";
        $self->{text} = $self->{canvas}->createText(400, 400, -text => $text, -font => "{EnterCommand Bold} 32", -fill => "#FFD5FC");

        $self->{canvas}->delete(@{$self->{obstacles}});

        $self->{mw}->bind('<KeyPress-r>', sub { 
            require Fenetre_menu; 
            Fenetre_menu->new->run; 
            $self->{mw}->destroy
        });
        return;
    }

    $self->{canvas}->delete($self->{rectangle});
    $self->{rectangle} = $self->{canvas}->createImage($Helicopter->getX1(), $Helicopter->getY1(), -image => $helicopter_image, -anchor => 'nw');

    $self->{mw}->after(40, [\&move_helicopter, $self, $Helicopter, $helicopter_image, $obstacles_ref]);
}


# create obstacles
sub get_obstacles {
    my ($self) = @_;
    my $obstacles_ref = Obstacle->getList();

    my @obstacles;
    foreach my $obstacle (@$obstacles_ref) {
        push @obstacles, [$obstacle->{x1}, $obstacle->{y1}, $obstacle->{x2}, $obstacle->{y2}, 0];
        my ($background_label, $rectangle) = $obstacle->create_rectangle_with_background($self);
        push @{$self->{obstacles}}, {background_label => $background_label, rectangle => $rectangle};
    }

    $self->get_heliport;
    my $heliport_ref = Heliport->getList();
    foreach my $heliport (@$heliport_ref) {
        push @obstacles, [$heliport->{x1}, $heliport->{y1}, 239, 42, $heliport->{win}];
    }
    return \@obstacles;
}

# create heliport
sub get_heliport {
    my ($self) = @_;
    my $heliport_ref = Heliport->getList();

    foreach my $heliport (@$heliport_ref) {
        my $image = $heliport->getImages();
        my $heliport_image = $self->{mw}->Photo(-format => 'png', -file => "assets/images/$image");

        $self->{heliport} = $self->{canvas}->createImage($heliport->getX1(), $heliport->getY1(), -image => $heliport_image, -anchor => 'nw');
    }
}



sub pre {
    my ($self) = @_;

    # Récupérer les dimensions de l'écran
    my $screen_width  = 800;
    my $screen_height = 800;

    # Déterminer les dimensions et la position de la fenêtre pour la centrer
    my $window_width  = 800;
    my $window_height = 800;


    # Générer la géométrie de la fenêtre pour la centrer
    #my $geometry = $window_width . 'x' . $window_height . '+' . $x_position . '+' . $y_position;
    #$self->{mw}->geometry($geometry);

    # Supprimer la barre de titre
    $self->{mw}->overrideredirect(1);

    # Créer le canevas et dessiner le rectangle
    $self->{canvas} = $self->{mw}->Canvas(-width => $window_width, -height => $window_height)->pack;

    # Charger l'image à utiliser comme arrière-plan
    my $background_image_file = 'assets/images/background.png';  
    my $background_image = $self->{mw}->Photo(-file => $background_image_file);

    # Créer un label pour afficher l'image en arrière-plan
    my $background_label = $self->{canvas}->createImage(0, 0, -image => $background_image, -anchor => 'nw');

    # $self->{rectangle} = $self->{canvas}->createRectangle(50, 50, 150, 150, -fill => 'blue');

    # Lier l'événement de pression de la touche "x" à la fermeture de la fenêtre
    $self->{mw}->bind('<KeyPress-x>', sub { $self->{mw}->destroy });
}

sub run {
    my $self = shift;
    Tk::MainLoop;
}

1;