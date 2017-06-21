import ObjectMapper

struct Post: Mappable{
    //속성추가
    
    var id: Int!
    var user: User!
    var photoID: String!
    var message: String?
    var isLiked: Bool!
    var likeCount: Int!
    var createdAt: Date!
    
    
    //실패할수 있는 생성자이므로 옵셔널
    init?(map: Map){
    }
    
    //var로 정의된 구조체에서만 mutating사용가능
    mutating func mapping(map: Map) {
        //ObjectMapper에서 제공하는 기능, 정의한연산자임,
        id <- map["id"]
        user <- map["user"] //user를 만들어서 또 뭘 만들어? User 구조체로 해서..어쩌구...궁금..ㅠ.ㅠ
        photoID <- map["photo.id"]
        message <- map["message"]
        isLiked <- map["is_liked"]
        likeCount <- map["like_count"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        //ISO-8601 날짜형식
    }
    
}

extension Notification.Name {
    
    ///좋아요를 할 경우 발생하는 Notification, 'userInfo'에 'postID: Int' 가 전달됩니다.
    //반드시 위와 같이 코멘트 한다.
    static var postDidLike: Notification.Name {
        //get 메소드만 작성시 아래와 같이 return바로 할 수 있음
        //return Notification.Name("postDidLike") //아래 중복 제거
        return .init("postDidLike")
    }
    
    //혹은 아래도 가능
    //static let postDidLike: Notification.Name = .init("postDidLike")
    
    
    ///좋아요를 취소 할 경우 발생하는 Notification, 'userInfo'에 'postID: Int' 가 전달됩니다.
    static var postDidUnLike: Notification.Name {
        //return Notification.Name("postDidUnLike")
        return .init("postDidUnLike")
    }
    
}
