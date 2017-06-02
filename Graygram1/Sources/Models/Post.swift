import ObjectMapper

struct Post: Mappable{
    //속성추가
    var id: Int!
    var message: String?
    var createdAt: Date!
    
    //실패할수 있는 생성자이므로 옵셔널
    init?(map: Map){
    }
    
    //var로 정의된 구조체에서만 mutating사용가능
    mutating func mapping(map: Map) {
        //ObjectMapper에서 제공하는 기능, 정의한연산자임,
        id <- map["id"]
        message <- map["message"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        //ISO-8601 날짜형식
    }
    
}
