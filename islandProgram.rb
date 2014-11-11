# -*- coding: utf-8 -*-


$linked_island = []#繋がっている島の番号。
sorting = []#中間配列。便宜的に使用
reached_island = []#たどり着いた島の番号
stamp_number = []

island_volume = 0#島全体の数
now_place_island = 0#現在いる島の番号。ここでは仮定義。下記のアルゴリズムで決定する。
will_go_island = 0#向おうとする島の番号。
$reached_island_volume = 0#到着した島の数。
get_point = 0#獲得ポイント数
start_time = 0#プログラム開始時刻
finish_time = 0#プログラム終了時刻
pass_time = 0#プログラム実行時の経過時間
output_file = 'stampsheet.txt'#訪れた島の番号を出力するファイル名。

class Search
  def start
    start_island = 0
    $linked_island.size.times{|i|
      if $linked_island[i].size < $linked_island[start_island].size
        start_island = i
      end
    }
    delete(start_island)
    return start_island
  end

  def go(k = 0)
    min_island  = 0
    load_island = []

    load_island = $linked_island[k]

    if load_island.size < 2 then
      min_island = load_island[0]
      delete(min_island)
      return min_island
    end
        if $linked_island[load_island[0]].size < $linked_island[load_island[1]].size
      min_island = load_island[0]
    else
      min_island = load_island[1]
    end
    for i in 2..load_island.size-1 
      if $linked_island[load_island[i]].size < $linked_island[min_island].size 
        min_island = load_island[i]
      end
    end
    delete(min_island)
    return min_island
  end

  def delete(island_number = 0)
    $linked_island.size.times{|i|
      $linked_island[i].delete(island_number)#最初の島は行けなくなるので全ての島からそれを削除。
    } 
    $reached_island_volume += 1#訪れた島の数を増加。
  end
end

class FileAccess
  def load(file_name)
    index = 0#島の番号
    open(file_name) {|file|
    while island_road_time = file.gets
      $linked_island[index] = island_road_time.split
      index += 1
      end
    }
  end

  def save(save_number)
    File.open('stampsheet.txt','a'){|f|
      f.puts "#{save_number}"
    }
  end
end

# この行を追加しました
# どんどん追加してみます 
# masterが追加しました

start_time = Time.now#開始時刻を設定。
# 新たに追加しました
search = Search.new
file_access = FileAccess.new

file_access.load('map.txt')

$linked_island.shift#最初の配列は島全体の数なので消去。

#読み込んだ配列は文字列なので数値として再格納。
for j in 0..$linked_island.size-1
  sorting[j] = $linked_island[j]
  for i in 0..sorting[j].size-1
    $linked_island[j][i] = sorting[j][i].to_i
  end
end

#出力ファイルの初期化。
File.open('stampsheet.txt','w'){|f|
}
File.unlink output_file



###メイン関数。ここからスタンプラリーが開始される。###

now_place_island = search.start#開始する島を決定。
file_access.save(now_place_island)
while $linked_island[now_place_island].size > 0#現在いる島から行くことのできる島がある時のみ以下を実行。
  now_place_island = search.go(now_place_island)#向う島を選択。
  file_access.save(now_place_island)
end

finish_time = Time.now#終了時刻を設定。
pass_time = finish_time - start_time#経過時間を算出。
if pass_time > 1800#経過時間が30分、つまり1800秒を超えたとき、
  puts "Time over, so you didn't get point."#ルールよりポイント獲得していないことを通知。
else#それ以外、つまり時間内にプログラムが実行終了したとき、ポイント、成果などを表示する。
  get_point = ($reached_island_volume**3)/($linked_island.size*pass_time)
  puts "The nunber of island you have visited is #{$reached_island_volume}."
  puts "The island you visited last is #{now_place_island}"
  puts "Pass time is #{pass_time} sec."
  puts "You got #{get_point} points."
end
