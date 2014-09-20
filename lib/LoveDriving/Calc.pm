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


sub get_drive_result {
    args(
        my $class,
        my $id => 'Str',
        my $content,
    );

    my $data = $class->_parse_data( $content );
    # 走行状況の計算結果の取得
    my $discomfort_result = $class->_calc_discomfort( $data );

    # 彼女不快指数の合計算出
    my $total_discomfort = LoveDriving::KV->get_discomfort( id => $id );
    $total_discomfort -= $discomfort_result->{reduce_value};

    # 彼女不快指数の保存
    my $is_save = LoveDriving::KV->save_discomfort(
        id         => $id,
        discomfort => $total_discomfort,
    );

    return {
        total_discomfort => $total_discomfort,
        discomfort_type  => $discomfort_result->{discomfort_type},
    };
}

# 減算される彼女不快指数を取得する
sub _calc_discomfort {
    my ( $class, $data ) = @_;

    my $reduce_value = 0;
    my $discomfort_type = {
        brake_flag => 0,
        curve_flag => 0,
    };

    # 急ブレーキの計算結果
    my $brake_value = $class->_get_brake_discomfort( $data );
    if ( $brake_value > 0 ) {
        $discomfort_type->{brake_flag} = 1;
    }
    $reduce_value += $brake_value;

    #TODO 急カーブの計算結果

    return {
        reduce_value    => $reduce_value,
        discomfort_type => $discomfort_type,
    }
}

# 急ブレーキによる不快指数を計算する
sub _get_brake_discomfort {
    my ( $class, $data ) = @_;

    my $brake_value = 0;
    # 車両の前後G
    my $vehicle_g = $data->{ALgt} / config()->{accela_gravity};

    # 加速度が超えていた場合
    if ( $vehicle_g > config()->{g_threshold} ) {
        $brake_value = config->{reduce_value};
    }

    return $brake_value;
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
