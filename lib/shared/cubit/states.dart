abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class GetUserLoadingState extends SocialStates {}

class GetUserSuccessState extends SocialStates {}

class GetUserErrorState extends SocialStates {
  final String error;

  GetUserErrorState(this.error);
}

class BottomNavChangeState extends SocialStates {}

class NewPostState extends SocialStates {}

class ProfileImagePickedSuccessState extends SocialStates {}

class ProfileImagePickedErrorState extends SocialStates {}

class UploadProfileImageSuccessState extends SocialStates {}

class UploadProfileImageErrorState extends SocialStates {}

class GetProfileImageUrlSuccessState extends SocialStates {}

class GetProfileImageUrlErrorState extends SocialStates {}

class CoverImagePickedSuccessState extends SocialStates {}

class CoverImagePickedErrorState extends SocialStates {}

class UploadCoverImageSuccessState extends SocialStates {}

class UploadCoverImageErrorState extends SocialStates {}

class GetCoverImageUrlSuccessState extends SocialStates {}

class GetCoverImageUrlErrorState extends SocialStates {}

class UpdateUserErrorState extends SocialStates {}

class UpdateUserDataLoadingState extends SocialStates {}

class CreatePostLoadingState extends SocialStates {}

class CreatePostSuccessState extends SocialStates {}

class CreatePostErrorState extends SocialStates {}

class PostImagePickedSuccessState extends SocialStates {}

class PostImagePickedErrorState extends SocialStates {}

class RemovePostImageState extends SocialStates {}

class GetPostsLoadingState extends SocialStates {}

class GetPostsSuccessState extends SocialStates {}

class GetPostsErrorState extends SocialStates {
  final String error;

  GetPostsErrorState(this.error);
}

class ChangePostLikeSuccessState extends SocialStates {}

class ChangePostLikeErrorState extends SocialStates {
  final String error;

  ChangePostLikeErrorState(this.error);
}

class ChangeCommentState extends SocialStates {}

class CreateCommentSuccessState extends SocialStates {}

class CreateCommentErrorState extends SocialStates {}

class GetAllUsersLoadingState extends SocialStates {}

class GetAllUsersSuccessState extends SocialStates {}

class GetAllUsersErrorState extends SocialStates {}

class SendMessageSuccessState extends SocialStates {}

class SendMessageErrorState extends SocialStates {}

class GetMessagesSuccessState extends SocialStates {}

class ChangeMessageState extends SocialStates {}
