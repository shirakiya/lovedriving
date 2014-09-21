package LoveDriving::Calc;
use strict;
use warnings;
use Smart::Args;
use LoveDriving::Base;
use LoveDriving::Calc::Discomfort;
use LoveDriving::KV;

# 開始処理
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
    my $discomfort_result = LoveDriving::Calc::Discomfort->get_reduce_value( data => $data );

    # 彼女不快指数の合計算出
    my $total_discomfort = LoveDriving::KV->get_discomfort( id => $id );
    $total_discomfort -= $discomfort_result->{reduce_value};
    # 0以下の場合は0を与える
    $total_discomfort < 0 and $total_discomfort = 0;

    my $discomfort_type = $discomfort_result->{discomfort_type};
    my $last_type       = LoveDriving::KV->get_type( id => $id );
    my $show_times = LoveDriving::KV->get_show_times( id => $id );

    # 新たに不快運転を検出した場合
    if ( $discomfort_type > 0 ) {
        $last_type  = $discomfort_type;
        $show_times = 0;
    } elsif ( $discomfort_type == 0 && $last_type > 0 ) {
        $discomfort_type = $last_type;
        $show_times++;
        if ( $show_times > config()->{show_times} ) {
            $show_times = 0;
            $discomfort_type = 0;
        }
    }

    # 彼女不快指数の保存
    my $is_save = LoveDriving::KV->save(
        id         => $id,
        discomfort => $total_discomfort,
        type       => $discomfort_type,
        show_times => $show_times,
    );

    return {
        total_discomfort => $total_discomfort,
        discomfort_type  => $discomfort_type,
    };
}


# 車両の停止判定
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


# 緯度経度のパース
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


# 終了処理
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
