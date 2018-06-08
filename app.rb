require 'sinatra'
require "sinatra/reloader"
require 'rest-client'
require 'json'
require 'httparty'
require 'nokogiri'
require 'uri'
require 'date'
require 'csv'

before do
    p "************************"
    p params
    p request.path_info #사용자가 요청보낸 경로
    p request.fullpath # 파라미터까지 포함한 경로
    p "************************"
end

get '/' do
  'Hello world! welcome'
end

get '/htmlfile' do
    send_file 'views/htmlfile.html'
end

get '/htmltag' do
    '<h1>html태그를 보낼수 있습니다.</h1>
    <ul>
        <li>1</li>
        <li>22</li>
        <li>333</li>
    </ul
    '
end

get '/welcome/:name' do
    "#{params[:name]}님 안녕하세요"
end

get '/cube/:num' do
    # input = params[:num].to_i
    # result = input ** 3
    # "<h1>#{result}</h1>"
    
    "#{params[:num].to_i ** 3}"
    
end

get '/erbfile' do
    @name = "5chang2"
    erb :erbfile
end

get '/lunch-array' do
    # 메뉴들을 배열에 저장한다.
    menu = ["20층", "김밥까페","시골집", "시래기"]
    # 하나를 추첨한다.
    @result = menu.sample
    # erb 파일에 담아서 랜더링한다.
    erb :luncharray
end

get '/lunch-hash' do
    #메뉴들이 저장된 배열을 만든다
    menu = ["짜장면", "볶음밥", "김밥"]
    #메뉴 이름(key) 사진 url(value)을 
    #가진 Hash 를 만든다
    menu_img = {
        "짜장면" => "http://www.ohfun.net/contents/article/images/2015/0607/1433677499050108.jpg",
        "볶음밥" => "https://t1.daumcdn.net/cfile/tistory/136532424F08529921",
        "김밥" => "https://i.ytimg.com/vi/60ANBnHjiDU/maxresdefault.jpg"
    }
    #랜덤으로 하나를 출력한다.
    @menu_result = menu.sample
    @menu_img = menu_img[@menu_result]
    #이름과 url을 넘겨서 erb를 랜더링 한다.
    erb :lunchhash
end

get '/randomgame/:name' do
    "랜덤게임입니다."
end

get '/lotto-sample' do
    #랜덤하게 로또번호 추첨
    @lotto = (1..45).to_a.sample(6).sort
    @lotto = [6, 11, 15, 17, 23, 39]
    #erb파일 랜더링
    url = "http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    @lotto_info = RestClient.get(url) # json
    @lotto_hash = JSON.parse(@lotto_info)
    
    @winner = []
    @lotto_hash.each do |k, v|
        if k.include?('drwtNo')
            #배열에 저장
            @winner << v
        end
    end
    
    #winner 와 lotto 를 비교해서
    #몇개가 일치하는지 연산
    @matchnum = (@winner & @lotto).length
    @bonusnum = @lotto_hash["bnusNo"]
    
    # 몇등인지????
    # if (@matchnum == 6) then @result = "1등"
    # elsif (@matchnum == 5 && @lotto.include?(@bonusnum))
    #     @result = "2등"
    # elsif (@matchnum == 5) then @result = "3등"
    # elsif (@matchnum == 4)
    #     @result = "4등"
    # elsif (@matchnum == 3)
    #     @result = "5등"
    # else 
    #     @result = "꽝"
    # end
    
    #몇등인지 ??? (case)
    
    @result = 
    case [@matchnum, @lotto.include?(@bonusnum)]
    when [6, false] then "1등"
    when [5, true] then "2등"
    when [5, false] then "3등"
    when [4, false] then "4등"
    when [3, false] then "5등"
    else '꽝'
    end
    
    erb :lottosample
end

get '/form' do
    erb :form
end

get '/search' do
    @keyword = params[:keyword]
    url = 'https://search.naver.com/search.naver?query='
    # erb :search
    redirect to (url+@keyword)
end

get '/opgg' do
    erb :opgg
end

get '/opggresult' do
    url = 'http://www.op.gg/summoner/userName='
    @userName = params[:userName]
    @encodeName = URI.encode(@userName)
    
    @res = HTTParty.get(url+@encodeName)
    @doc = Nokogiri::HTML(@res.body)
    
    @win = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins")
    @lose = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses") 
    @rank = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierRank > span")
    erb :opggresult
end
