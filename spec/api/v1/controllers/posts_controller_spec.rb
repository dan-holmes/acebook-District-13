require 'rails_helper'

RSpec.describe Api::V1::PostsController do 
  before do
    post_user = instance_double("User", 
    username: "arabellsy", 
    email: "araknwlo@gmail.com", 
    full_name: "A Dog", 
    password: "adoggle",
    id: 1)  

    
    allow_any_instance_of(Api::V1::PostsController).to receive(:current_user).and_return(post_user)
  end

  describe "POST #create" do
    

    it 'successfully creates a post' do
      post '/api/v1/posts', params: { message: "hello" }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("hello")
    end

    # it 'renders an error if a post is not created' do
    #   @current_user = nil
    #   post '/api/v1/posts', params: { message: 'this message should not be created' }
    #   expect(response).to have_http_status(:error)
    #   json = JSON.parse(response.body)
    #   expect(json["error"]).to eq("Unable to create post.")
    # end

    # renders error test - look at delete test for more info
  end

  context "Users and posts created before" do
    before do
      User.create(id: 1, username: 'AD0G', full_name: 'Azza Kno', password: 'binupx3', email: 'dogz@makers.com' )
      User.create(id: 2, username: 'ACAT', full_name: 'Azzar Kno', password: 'binupx4', email: 'catz@makers.com' )
      User.create(id: 3, username: 'AMOUSE', full_name: 'Aza Kno', password: 'binupx5', email: 'mice@makers.com' )
      Post.create(id: 1, message: "Dogs over cats, sue me", user_id: 1)
      Post.create(id: 2, message: "Cats over dogs, sue you", user_id: 2)
      Post.create(id: 3, message: "Hello district 13", user_id: 1)
    end

    describe "GET #show" do
      it 'returns the post' do
        get '/api/v1/posts/1'
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Dogs over cats, sue me")
      end

      # it 'returns a success status' do
      #   expect(response).to have_http_status(200)
      # end
      # do not currently render a http status in api posts controller?
    end

    describe "GET #index" do
      it 'returns the post' do
        get '/api/v1/posts'
        json = JSON.parse(response.body)
        json_posts = json["posts"]
        expect(json_posts[0]["message"]).to eq("Hello district 13")
        expect(json_posts[1]["message"]).to eq("Cats over dogs, sue you")
        expect(json_posts[2]["message"]).to eq("Dogs over cats, sue me")
      end

      # test for http status?
    end

    describe "DELETE #destroy" do
      it 'successfully deletes post' do
        delete '/api/v1/posts/1'
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['message']).to eq 'Post successfully deleted'
      end

      it 'throws error when trying to delete a post that does not exist' do
        delete '/api/v1/posts/2'
        expect(response).to have_http_status(:error)
        json = JSON.parse(response.body)
        expect(json['error']).to eq 'Unable to delete post'
        # failing: ActiveRecord::RecordNotFound:Couldn't find Post with 'id'=8, find_post method
        # does find_post use user id to find the post? 
      end
      
    end

    describe "UPDATE #update" do 
      it 'successfully updates a post' do 
        patch '/api/v1/posts/1', params: { message: "Successfully updated message " }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['message']).to eq 'Post successfully updated'
      end

      it 'renders an error when trying to update a post that does not belong to them' do
        patch '/api/v1/posts/2', params: { message: "I shouldn't be able to do this"}
        expect(response).to have_http_status(:error)
        json = JSON.parse(response.body)
        expect(json['error']).to eq 'Unable to update post'
      end
  
    end

  end

end