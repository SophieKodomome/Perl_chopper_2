#!/usr/bin/perl
use strict;
use warnings;
use DBI;

package MyCon;

sub getMySQLCon {
    my $db_name = "helicopter";
    my $username = "root";
    my $password = "";
    my $host = "localhost";
    my $port = "3306";

    my $dsn = "DBI:mysql:database=$db_name;host=$host;port=$port";
    my $dbh = DBI->connect($dsn, $username, $password, {AutoCommit => 1, RaiseError => 1, PrintError => 0});
    unless ($dbh) {
        die "Error connecting to database: " . DBI->errstr;
    }

    return $dbh;
}

# Fonction pour récupérer une valeur d'une colonne d'une table
sub selectChiffre {
    my ($self, $table, $col, $condition) = @_;

    my $valiny = 0;
    my $dbh = getMySQLCon();

    my $sql = "SELECT $col FROM $table $condition";
    my $sth = $dbh->prepare($sql);
    $sth->execute();

    if (my $row = $sth->fetchrow_arrayref()) {
        $valiny = $row->[0] + 1;
    }

    $sth->finish();
    $dbh->disconnect();

    return $valiny;
}

# Vérifier si une certaine valeur existe dans une colonne d'une table
sub misyVe {
    my ($self, $table, $mot, $col) = @_;

    my $boo = 0;
    my $dbh = getMySQLCon();

    my $sql = "SELECT $col FROM $table WHERE $col = ?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($mot);

    $boo = 1 if $sth->fetchrow_arrayref();

    $sth->finish();
    $dbh->disconnect();

    return $boo;
}

# Sélectionner des données de la table
sub select {
    my ($self, $table, $columns, $condition) = @_;

    my $resultList = [];
    my $dbh = getMySQLCon();

    my $column = join(", ", @$columns);
    my $sql = "SELECT $column FROM $table $condition";
    my $sth = $dbh->prepare($sql);
    $sth->execute();

    my $metaData = $sth->{NAME};
    my $columnCount = scalar(@$metaData);

    while (my $row = $sth->fetchrow_arrayref()) {
        my %hashRow;
        for (my $i = 0; $i < $columnCount; $i++) {
            $hashRow{$metaData->[$i]} = $row->[$i];
        }
        push @$resultList, \%hashRow;
    }

    $sth->finish();
    $dbh->disconnect();

    return $resultList;
}
1;