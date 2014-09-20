package LoveDriving::Calc;
use strict;
use warnings;
use Smart::Args;
use LoveDriving::Base;
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

    my $total_discomfort = LoveDriving::KV->get_discomfort( id => $id );

    #TODO 不快指数の計算
    my $discomfort = 0; #仮実装
    $total_discomfort -= $discomfort;

    my $is_save = LoveDriving::KV->save_discomfort(
        id         => $id,
        discomfort => $total_discomfort,
    );

    return $total_discomfort;
}


sub _calc_discomfort {
    my ($class, $content) = @_;

    my $data = $class->_parse_data( $content );
    my $reduce_value = 0;

    my $brake_value = 0;

    my $ALgt = $data->{ALgt};
    my $vehicle_g = $ALgt / config()->{accela_gravity};

    # 加速度が超えていた場合
    if ( $vehicle_g < config()->{g_threshold} ) {
    }
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


sub parse_position {
    args(
        my $class,
        my $content,
    );

    return {
        lat => $class->_parse_data( $content )->{Posn}->{lat},
        lon => $class->_parse_data( $content )->{Posn}->{lon},
    };
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
