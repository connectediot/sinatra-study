require 'sinatra'
require "sinatra/reloader"

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
    
end
