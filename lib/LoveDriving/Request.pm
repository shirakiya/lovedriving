package LoveDriving::Request;
use strict;
use warnings;
use Smart::Args;
use Furl;
use JSON;
use LoveDriving::Base;
use Data::Dumper;

sub vehicle_info {
    args(
        my $class,
        my $id => 'Str',
    );

    my $furl = Furl->new;
    my $url = config()->{url_vehicleinfo};
    my $header = [
		'Content-Type: application/x-www-form-urlencoded',
    ];
    my $res = $furl->post( $url, $header, [
        developerkey   => config()->{developer_key},
        responseformat => 'json',
        userid         => "ITCJP_USERID_$id",
        infoids        => '[Spd,BrkIndcr]',
    ] );
    die $res->status_line unless $res->is_success;
    print Dumper decode_json($res->content);

    return decode_json($res->content);
}


1;
