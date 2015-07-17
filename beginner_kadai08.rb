# ------------------------------------------------------- #
# Run as:
# $ ruby beginner_kadai08.rb
# ------------------------------------------------------- #

## レコードフォーマット

class TourRecord
  def initialize(record)
    @record = record
  end

  # ID
  def id
    @record[0..4].to_i
  end

  # ツアー名称
  def name
    @record[5..14].strip
  end

  # ツアー旅費
  def travel_expenses
    @record[15..21].to_i
  end

  # ツアー参加人数
  def persons
    @record[22..25].to_i
  end

  # ツアー支払い金額
  def payment
    @record[26..37].to_i
  end
end


## メソッド

def comma(num)
  '¥' << num.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')
end


## 入力処理(ツアーマスタの読み込み)
begin
  puts "\n入力:"

  # 配列の用意
  tours = Array::new

  open('tour-master.dat'.upcase) do |file|
    while line = file.gets
      puts line
      tour = TourRecord::new(line)
      tours << {
        'id' => tour.id,
        'name' => tour.name,
        'travel_expenses' => tour.travel_expenses,
        'persons' => tour.persons,
        'payment' => tour.payment
      }
    end
  end

  # ID順ソート
  tours.sort! { |a, b| a['id'] <=> b['id'] }
end


## 出力処理(明細の出力)

begin
  puts "\n出力:"

  File.open('sysprint.dat'.upcase, 'w') do |file|

    # 見出し行
    header = format("%10s", "ﾂｱｰﾒｲ") \
          << format("%11s", "ﾘｮﾋ") \
          << format("%7s", "ﾆﾝｽﾞｳ") \
          << format("%15s", "ｷﾝｶﾞｸ") \
          << "\n"
    puts header += "-" * 43 << "\n"
    file.write header

    # 明細行(ツアー契約一覧)
    tours.each do |tour|
      # puts tour
      puts line  = format("%10s", tour["name"]) \
                << format("%11s", comma(tour["travel_expenses"])) \
                << format("%7s", tour["persons"]) \
                << format("%15s", comma(tour["payment"]))
      file.write(line << "\n")
    end

    # 集計行(合計旅費／合計参加人数／合計支払い金額の演算)
    footer = "-" * 43 << "\n" #
    puts footer += format("%10s", "ｺﾞｳｹｲ") \
                << format("%11s", comma(tours.inject(0) {|sum, n| sum + n["travel_expenses"] }) ) \
                << format("%7s",  tours.inject(0) {|sum, n| sum + n["persons"] }) \
                << format("%15s", comma(tours.inject(0) {|sum, n| sum + n["payment"] }) ) \
                << "\n"
    file.write footer

  end

end


