package Model::Request;
use strict;
use warnings;
use Smart::Args;
use Furl;
use JSON qw/decode_json/;
use File::Spec;
use File::Basename;

sub vehicle_info {
    args(
        my $class,
        my $id => 'Int',
        my $developer_key => 'Str',
    );

    my $furl = Furl->new;
    my $url = 'https://api-jp-t-itc.com/GetVehicleInfo';
    my $header = [
		'Content-Type: application/x-www-form-urlencoded',
    ];
    my $res = $furl->post( $url, $header, [
        developerkey => &_get_developer_key,
        responseformat => 'json',
        userid => 'ITCJP_USERID_001',
        infoids => '[Spd,BrkIndcr]',
    ] );
    die $res->status_line unless $res->is_success;

    my $res_decoded = decode_json($res->content);

    return $res_decoded;
}


sub _get_developer_key {
    my $basedir = File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__) ) );
    my $config = do File::Spec->catfile( $basedir, 'config.pl' )
      or die;
    
    return $config->{developerkey};
}

1;
