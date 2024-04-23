#!/usr/bin/perl
use strict;
use warnings;
use Tk;
use Tk::PNG;
use Tk::JPEG;
use lib '.';

use Fenetre_jeu;

package Fenetre_menu;

sub new {
    my ($class) = @_;
    my $self = {
        mw => MainWindow->new,
        canvas => undef,
        rectangle => undef,
    };
    bless $self, $class;
    $self->_init;
    return $self;
}

sub _init {
    my ($self) = @_;
    $self->create_screen;
    my $mw = $self->{mw};

    my $titre = $self->{mw}->Photo(-format => 'png', -file => "assets/images/titre.png");
    $self->{rectangle} = $self->{canvas}->createImage(400, 400, -image => $titre);

    $self->{button} = $self->create_play_button;
    $self->{button} = $self->create_quit_button;
}


# button
sub create_play_button {
    my $self = shift;

    my $play_button = $self->{mw}->Button(
        -text => "Play",
        -font => "{EnterCommand} 16",
        -background => "#fdeae0",      # Couleur de fond
        -foreground => "#0a143f",      # Couleur du texte
        -activebackground => "#0a143f",# Couleur de fond lors du survol
        -activeforeground => "#f64967",# Couleur du texte lors du survol
        -borderwidth => 10,             # Pas de bordure
        -highlightthickness => 0,      # Pas de mise en évidence
        -padx => 100,                   # Remplissage horizontal
        -pady => 14,                   # Remplissage vertical
        -command => sub { $self->play },    # Action à exécuter lors du clic
    );
    $play_button->configure(
        -highlightcolor => "#EBD3EA",  # Couleur de mise en évidence
    );
    $play_button->place(
        -relx => 0.5,
        -rely => 0.7,
        -anchor => 'center',
    );
    return $play_button;
}

sub play {
    my $self = shift;
    require Fenetre_jeu; 
    Fenetre_jeu->new->run; 
    $self->{mw}->destroy; 
}

sub create_quit_button {
    my $self = shift;

    my $quit_button = $self->{mw}->Button(
        -text => "quit",
        -font => "{EnterCommand} 16",
        -background => "#fdeae0",      # Couleur de fond
        -foreground => "#0a143f",      # Couleur du texte
        -activebackground => "#0a143f",# Couleur de fond lors du survol
        -activeforeground => "#f64967",# Couleur du texte lors du survol
        -borderwidth => 10,             # Pas de bordure
        -highlightthickness => 0,      # Pas de mise en évidence
        -padx => 100,                   # Remplissage horizontal
        -pady => 14,                   # Remplissage vertical
        -command => sub { $self->quit},    # Action à exécuter lors du clic
    );
    $quit_button->configure(
        -highlightcolor => "#EBD3EA",  # Couleur de mise en évidence
    );
    $quit_button->place(
        -relx => 0.5,
        -rely => 0.85,
        -anchor => 'center',
    );
    return $quit_button;
}


sub create_screen {
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

    # Lier l'événement de pression de la touche "x" à la fermeture de la fenêtre
    $self->{mw}->bind('<KeyPress-x>', sub{$self->quit});
}
sub quit {
    my $self = shift;
    $self->{mw}->destroy;

}
sub run {
    my $self = shift;
    Tk::MainLoop;
}

1;