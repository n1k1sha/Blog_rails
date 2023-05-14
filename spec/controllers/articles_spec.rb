require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }
    let(:my_article) { create(:article, user: user) }
    let(:other_article) { create(:article) }
  
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
  
      context "when user is signed in" do
        before { sign_in user }
  
        it "returns http success" do
          get :index
          expect(response).to have_http_status(:success)
        end
  
        it "assigns @articles to current user's articles when filter is 'My'" do
          get :index, params: { filter: "My" }
          expect(assigns(:articles)).to eq([my_article])
        end
  
        it "assigns @articles to all articles when filter is not 'My'" do
          get :index
          expect(assigns(:articles)).to eq([other_article, article])
        end
      end
  
      context "when user is not signed in" do
        it "returns http success" do
          get :index
          expect(response).to have_http_status(:success)
        end
  
        it "assigns @articles to all articles" do
          get :index
          expect(assigns(:articles)).to eq([other_article, article])
        end
      end
    end
  
    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: article.id }
        expect(response).to have_http_status(:success)
      end
  
      it "assigns @article to the requested article" do
        get :show, params: { id: article.id }
        expect(assigns(:article)).to eq(article)
      end
    end
  
    describe "GET #new" do
      context "when user is signed in" do
        before { sign_in user }
  
        it "returns http success" do
          get :new
          expect(response).to have_http_status(:success)
        end
  
        it "assigns @article to a new article" do
          get :new
          expect(assigns(:article)).to be_a_new(Article)
        end
      end
    end
  
    describe "POST #create" do
      context "when user is signed in" do
        before { sign_in user }
  
        context "with valid attributes" do
          it "creates a new article" do
            expect {
              post :create, params: { article: attributes_for(:article) }
            }.to change(Article, :count).by(1)
          end
  
          it "assigns @article to the newly created article" do
            post :create, params: { article: attributes_for(:article) }
            expect(assigns(:article)).to be_an_instance_of(Article)
            expect(assigns(:article)).to be_persisted
          end
  
          it "redirects to the newly created article" do
            post :create, params: { article: attributes_for(:article) }
            expect(response).to redirect_to(assigns(:article))
          end
        end
  
        context "with invalid attributes" do
          it "does not create a new article" do
            expect {
              post :create, params: { article: attributes_for(:article, title: nil) }
            }.not_to change(Article, :count)
          end
  
          it "assigns @article to a new unsaved article" do
            post :create, params: { article: attributes_for(:article, title: nil) }
            expect(assigns(:article)).to be_a_new(Article)
          end
  
          it "renders the new template with unprocessable_entity status" do
            post :create, params: { article: attributes_for(:article, title: nil) }
            expect(response).to render_template(:new)
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  
    describe "GET #edit" do
      context "when user is signed in" do
        before { sign_in user }
  
        it "returns http success" do
          get :edit, params: { id: article.id }
          expect(response).to have_http_status(:success)
        end
  
        it "assigns @article to the requested article" do
          get :edit, params: { id: article.id }
          expect(assigns(:article)).to eq(article)
        end
      end
    end
  
    describe "PATCH #update" do
      context "when user is signed in" do
        before { sign_in user }
  
        context "with valid attributes" do
          it "updates the requested article" do
            patch :update, params: { id: article.id, article: { title: "New Title" } }
            expect(article.reload.title).to eq("New Title")
          end
  
          it "assigns @article to the updated article" do
            patch :update, params: { id: article.id, article: { title: "New Title" } }
            expect(assigns(:article)).to eq(article)
          end
  
          it "redirects to the updated article" do
            patch :update, params: { id: article.id, article: { title: "New Title" } }
            expect(response).to redirect_to(article)
          end
        end
  
        context "with invalid attributes" do
          it "does not update the requested article" do
            patch :update, params: { id: article.id, article: { title: nil } }
            expect(article.reload.title).not_to be_nil
          end
  
          it "assigns @article to the unsaved article" do
            patch :update, params: { id: article.id, article: { title: nil } }
            expect(assigns(:article)).to eq(article)
          end
  
          it "renders the edit template with unprocessable_entity status" do
            patch :update, params: { id: article.id, article: { title: nil } }
            expect(response).to render_template(:edit)
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  
    describe "DELETE #destroy" do
      context "when user is signed in" do
        before { sign_in user }
  
        it "destroys the requested article" do
          article_to_destroy = create(:article, user: user)
          expect {
            delete :destroy, params: { id: article_to_destroy.id }
          }.to change(Article, :count).by(-1)
        end
  
        it "redirects to root path with see_other status" do
          delete :destroy, params: { id: article.id }
          expect(response).to redirect_to(root_path)
          expect(response).to have_http_status(:see_other)
        end
      end
    end
  end
  