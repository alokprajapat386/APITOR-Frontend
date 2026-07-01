
class GoogleOauthRequestDTO {
   final String tokenId;
   
   GoogleOauthRequestDTO({
    required this.tokenId
   });

   Map<String, dynamic> toJson(){
      return {
        'tokenId': tokenId
      };
   }
}