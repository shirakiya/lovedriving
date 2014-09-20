package LoveDriving::Base;
use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;

use parent 'Exporter';
our @EXPORT = qw/ config unqlite /;

our $CONFIG;
our $UNQLITE;

sub config {
    $CONFIG ||= sub {
        my $basedir = File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__), '../../' ) );
        return do File::Spec->catfile( $basedir, 'config.pl' )
    }->();
    return $CONFIG;
}

sub unqlite {
    my $class = shift;

    $UNQLITE ||= UnQLite->open(config()->{database_name});
    return $UNQLITE;
}

1;
