package LoveDriving::Calc::Discomfort;
use strict;
use warnings;
use Smart::Args;
use LoveDriving::Base;
use Data::Dumper;

# 減算される彼女不快指数を取得する
sub get_reduce_value {
    args(
        my $class,
        my $data,
    );

    my $reduce_value = 0;
    my $discomfort_type = {
        brake_flag       => 0,
        jumpstart_flag   => 0,
        stopbrake_flag   => 0,
        curve_flag       => 0,
    };

    # 急加速度の計算結果
    my $accela_result = $class->_get_accela_discomfort( $data );

    if ( $accela_result->{accela_discomfort} > 0 ) {
        $reduce_value += $accela_result->{accela_discomfort};

        if ( $accela_result->{accela_type} == config()->{brake_flag} ) {
            $discomfort_type->{brake_flag} = config()->{brake_flag};
        } elsif ( $accela_result->{accela_type} == config()->{jumpstart_flag} ) {
            $discomfort_type->{jumpstart_flag} = config()->{jumpstart_flag};
        }
    }

    # 停車前のブレーキの計算結果
    my $stopbrake_discomfort = $class->_get_stopbrake_discomfort( $data );

    if ( $stopbrake_discomfort > 0 ) {
        $reduce_value += $stopbrake_discomfort;
        $discomfort_type->{stopbrake_flag} = config()->{stopbrake_flag};
    }

    #TODO 急カーブの計算結果
    my $curve_discomfort = $class->_get_curve_discomfort( $data );

    if ( $curve_discomfort > 0 ) {
        $reduce_value += $curve_discomfort;
        $discomfort_type->{curve_flag} = config()->{curve_flag};
    }

    #TODO 車線変更の計算結果
    #my $lanechange_discomfort = $class->_get_lanechenge_discomfort( $data );

    #if ( $lanechange_discomfort > 0 ) {
    #    $reduce_value += $lanechange_discomfort;
    #    $discomfort_type->{lanechange} = config()->{lanechange_flag};
    #}

    # フラグの選択
    $discomfort_type = $class->_choice_flags( $discomfort_type );

    return {
        reduce_value    => $reduce_value,
        discomfort_type => $discomfort_type,
    }
}


# 急加速度による彼女不快指数を計算する
sub _get_accela_discomfort {
    my ( $class, $data ) = @_;

    my $accela_discomfort = 0;
    my $type;
    # 車両の前後G
    my $vehicle_g = $data->{ALgt} / config()->{accela_gravity};

    # 加速度が閾値を超えていた場合
    if ( abs( $vehicle_g ) > config()->{g_threshold_accela} ) {
        $accela_discomfort = config()->{reduce_value};
        # 加速度の正負で急発進・急ブレーキを判定
        if ( $vehicle_g < 0 ) {
            $type = config()->{brake_flag};
        } elsif ( $vehicle_g > 0 ) {
            $type = config()->{jumpstart_flag};
        }
    }

    return {
        accela_discomfort => $accela_discomfort,
        accela_type       => $type,
    };
}


# 停車前のブレーキによる彼女不快指数を計算する
sub _get_stopbrake_discomfort {
    my ( $class, $data ) = @_;

    my $stopbrake_discomfort = 0;
    # 必要なデータを変数に格納
    my $spd      = abs( $data->{Spd} );
    my $algt     = $data->{ALgt};
    my $is_brake = $data->{BrkIndcr}*1;
    
    if ( $is_brake == 1 ) {
        if ( $spd < config()->{spd_threshold_stopbrake} 
            && $algt < config()->{algt_threshold_stopbrake} ) {

            $stopbrake_discomfort = config()->{reduce_value};
        }
    }

    return $stopbrake_discomfort,
}


# 急カーブによる不快指数を計算する
sub _get_curve_discomfort {
    my ( $class, $data ) = @_;

    my $curve_discomfort = 0;

    #計算ロジック

    return $curve_discomfort;
}


#TODO 車線変更による不快指数を計算する
sub _get_lanechenge_discomfort {
    my ( $class, $data ) = @_;
    return;
}


# フラグの選択
sub _choice_flags {
    my ( $class, $type ) = @_;

    my @flags = sort { $a <=> $b } values( %$type );
    my $discomfort_type = pop( @flags );

    return $discomfort_type;
}

1;
