package Model::Request;
use strict;
use warnings;
use Smart::Args;
use Furl;
use JSON qw/decode_json/;
use File::Spec;
use File::Basename;
use Data::Dumper;

sub vehicle_info {
    args(
        my $class,
        my $id => 'Str',
    );

    my $furl = Furl->new;
    my $url = $class->_get_url_vehicleinfo;
    my $header = [
		'Content-Type: application/x-www-form-urlencoded',
    ];
    my $res = $furl->post( $url, $header, [
        developerkey => $class->_get_developer_key,
        responseformat => 'json',
        userid => "ITCJP_USERID_$id",
        infoids => '[Spd,BrkIndcr]',
    ] );
    die $res->status_line unless $res->is_success;
    print Dumper decode_json($res->content);

    return decode_json($res->content);
}


sub _get_config {
    my $basedir = File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__), '../../' ) );
    my $config = do File::Spec->catfile( $basedir, 'config.pl' )
      or die;

    return $config;
}


sub _get_developer_key {
    my $class = shift;
    my $config = $class->_get_config;
    return $config->{developer_key};
}


sub _get_url_vehicleinfo {
    my $class = shift;
    my $config = $class->_get_config;
    return $config->{url_vehicleinfo};
}

1;
