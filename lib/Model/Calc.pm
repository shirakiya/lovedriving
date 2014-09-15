package Model::Calc;
use strict;
use warnings;
use Smart::Args;
use UnQLite;

sub get_discomfort {
    args(
        my $class,
        my $id => 'Str',
        my $content,
    );

    my $db = UnQLite->open('lovedriving.db');
    my $sum_discomfort = $db->kv_fetch( $id ) or 0;

    #TODO 不快指数の計算
    my $discomfort = 0; #仮実装
    $sum_discomfort += $discomfort;

    $db->kv_store( $id, $sum_discomfort );

    return $sum_discomfort;
}


sub get_is_stop {
    args(
        my $class,
        my $content,
    );

    my $data = $class->_parse_data( $content );
    my $spd = $data->{Spd};

    my $is_stop = 0;
    # 車速が1以下なら停止と見なす
    if ( $spd*1 <= 1 ) {
        $is_stop = 1;
    }

    return $is_stop;
}


sub _parse_data {
    my ($class, $content) = @_;
    return $content->{vehicleinfo}[0]->{data}[0];
}

1;
