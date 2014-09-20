package LoveDriving::Calc;
use strict;
use warnings;
use Smart::Args;
use LoveDriving::KV;

sub start {
    args(
        my $class,
    );

    my $start_res = LoveDriving::KV->start();

    return $start_res;
}


sub get_discomfort {
    args(
        my $class,
        my $id => 'Str',
        my $content,
    );

    my $sum_discomfort = LoveDriving::KV->get_discomfort( id => $id );

    #TODO 不快指数の計算
    my $discomfort = 0; #仮実装
    $sum_discomfort += $discomfort;

    my $is_save = LoveDriving::KV->save_discomfort(
        id         => $id,
        discomfort => $sum_discomfort,
    );

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


sub end {
    args(
        my $class,
        my $id => 'Str',
    );

    my $is_end = LoveDriving::KV->end( id => $id );

    return $is_end;
}


sub _parse_data {
    my ($class, $content) = @_;
    return $content->{vehicleinfo}[0]->{data}[0];
}

1;
