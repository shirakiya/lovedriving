package LoveDriving::Calc::Discomfort;
use strict;
use warnings;
use Smart::Args;
use LoveDriving::Base;

# 減算される彼女不快指数を取得する
sub get_reduce_value {
    args(
        my $class,
        my $data,
    );

    my $reduce_value = 0;
    my $discomfort_type = {
        brake_flag       => 0,
        jump_start_flag  => 0,
        curve_flag       => 0,
    };

    # 急加速度の計算結果
    my $accela_result = $class->_get_accela_discomfort( $data );

    if ( $accela_result->{accela_discomfort} > 0 ) {
        $reduce_value += $accela_result->{accela_discomfort};

        if ( $accela_result->{accela_type} == config()->{brake_flag} ) {
            $discomfort_type->{brake_flag} = 1;
        } elsif ( $accela_result->{accela_type} == config()->{jamp_start_flag} ) {
            $discomfort_type->{jump_start_flag} = 1;
        }
    }

    #TODO 急カーブの計算結果
    $reduce_value += 0;

    return {
        reduce_value    => $reduce_value,
        discomfort_type => $discomfort_type,
    }
}


# 急加速度による不快指数を計算する
sub _get_accela_discomfort {
    my ( $class, $data ) = @_;

    my $accela_discomfort = 0;
    # 車両の前後G
    my $vehicle_g = $data->{ALgt} / config()->{accela_gravity};
    my $is_brake = $data->{BrkIndcr};
    my $type;

    # 加速度が閾値を超えていた場合
    if ( abs( $vehicle_g ) > config()->{g_threshold} ) {
        $accela_discomfort = config()->{reduce_value};
        # ブレーキ中なのかどうかで急発進・急ブレーキを判定
        if ( $is_brake == 1 ) {
            $type = config()->{brake_flag};
        } elsif ( $is_brake == 0 ) {
            $type = config()->{jamp_start_flag};
        }
    }

    return {
        accela_discomfort => $accela_discomfort,
        accela_type       => $type,
    };
}


# 急カーブによる不快指数を計算する
sub _get_curve_discomfort {
    my ( $class, $data ) = @_;

    my $curve_discomfort = 0;

    return $curve_discomfort;
}


1;
