require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do 
          visit new_user_path
          expect {
            fill_in 'user_email', with: 'm@example.com'
            fill_in 'user_password', with: '12345678'
            fill_in 'user_password_confirmation', with: '12345678'
            click_button 'SignUp'
          }.to change { User.count }.by(1)
          expect(page).to have_content('User was successfully created.')
        end # it 'ユーザーの新規作成が成功する' do 
      end # context 'フォームの入力値が正常' do
      context 'ユーザーの新規作成が失敗する' do
        it 'メールアドレスが未入力' do
          visit new_user_path
          expect {
            fill_in 'user_email', with: ''
            fill_in 'user_password', with: '12345678'
            fill_in 'user_password_confirmation', with: '12345678'
            click_button 'SignUp'
          }.to change { User.count }.by(0)
          expect(current_path).to eq users_path
          expect(page).to have_content("Email can't be blank")
        end
        it 'パスワードが未入力' do
          visit new_user_path
          expect {
            fill_in 'user_email', with: 'none@example.com'
            fill_in 'user_password', with: ''
            fill_in 'user_password_confirmation', with: ''
            click_button 'SignUp'
          }.to change { User.count }.by(0)
          expect(current_path).to eq users_path
          expect(page).to have_content("Password is too short (minimum is 3 characters)")
          expect(page).to have_content("Password confirmation can't be blank")
        end
        it 'パスワードが異なる' do
          visit new_user_path
          expect {
            fill_in 'user_email', with: 'none@example.com'
            fill_in 'user_password', with: 'aaa'
            fill_in 'user_password_confirmation', with: 'bbb'
            click_button 'SignUp'
          }.to change { User.count }.by(0)
          expect(current_path).to eq users_path
          expect(page).to have_content("Password confirmation doesn't match Password")
        end     
        it '登録済のメールアドレスを使用' do
          user = create(:user)
          visit new_user_path
          expect {
            fill_in 'user_email', with: user.email
            fill_in 'user_password', with: 'aaa'
            fill_in 'user_password_confirmation', with: 'aaa'
            click_button 'SignUp'
          }.to change { User.count }.by(0)
          expect(current_path).to eq users_path
          expect(page).to have_content("Email has already been taken")
        end   
      end
    end # describe 'ユーザー新規登録' do

    describe 'ログインしていない状態' do
      context 'マイページ' do
        it 'マイページへのアクセスが失敗する' do
          visit users_path(1)
          expect(current_path).to eq login_path
          expect(page).to have_content("Login required")
        end # it 'マイページへのアクセスが失敗する' do
      end # describe 'マイページ' do
    end # describe 'ログインしていない状態' do
  end # describe 'ログイン前' do

  describe 'ログイン後' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          # login user
          visit login_path
          fill_in 'email', with: user.email
          fill_in 'password', with: '12345678'
          click_button 'Login'
          expect(current_path).to eq root_path
          expect(page).to have_content('Login successful')
          click_link  'Mypage'
          expect(current_path).to eq user_path(user)
          click_link  'Edit'
          expect(current_path).to eq edit_user_path(user)
          fill_in 'user_email', with: 'm@example.com'
          fill_in 'user_password', with: '12345678'
          fill_in 'user_password_confirmation', with: '12345678'
          click_button 'Update'
          expect(page).to have_content('User was successfully updated.')
        end # it 'ユーザーの編集が成功する' do
      end # context 'フォームの入力値が正常' do
      context 'ユーザーの編集が失敗する' do
        before do
          # login user
          visit login_path
          fill_in 'email', with: user.email
          fill_in 'password', with: '12345678'
          click_button 'Login'
          expect(current_path).to eq root_path
          expect(page).to have_content('Login successful')
        end
        it 'メールアドレスが未入力' do
          visit edit_user_path(user)

          fill_in 'user_email', with: ''
          fill_in 'user_password', with: '12345678'
          fill_in 'user_password_confirmation', with: '12345678'
          click_button 'Update'

          expect(current_path).to eq user_path(user)
          expect(page).to have_content("Email can't be blank")
        end
        # it 'パスワードが未入力' do
        #   visit edit_user_path(user)

        #   fill_in 'user_email', with: 'none@example.com'
        #   fill_in 'user_password', with: ''
        #   fill_in 'user_password_confirmation', with: ''
        #   click_button 'Update'

        #   expect(current_path).to eq user_path(user)
        #   expect(page).to have_content("Password is too short (minimum is 3 characters)")
        #   expect(page).to have_content("Password confirmation can't be blank")
        # end
        it 'パスワードが異なる' do
          visit edit_user_path(user)

          fill_in 'user_email', with: 'none@example.com'
          fill_in 'user_password', with: 'aaa'
          fill_in 'user_password_confirmation', with: 'bbb'
          click_button 'Update'

          expect(current_path).to eq user_path(user)
          expect(page).to have_content("Password confirmation doesn't match Password")
        end     
        it '登録済のメールアドレスを使用' do
          visit edit_user_path(user)

          fill_in 'user_email', with: other_user.email
          fill_in 'user_password', with: 'aaa'
          fill_in 'user_password_confirmation', with: 'aaa'
          click_button 'Update'

          expect(current_path).to eq user_path(user)
          expect(page).to have_content("Email has already been taken")
        end # it '登録済のメールアドレスを使用' do
      end # context 'ユーザーの編集が失敗する' do
    end # describe 'ユーザー編集' do

    describe 'マイページ' do
      context 'タスクを作成' do
        before do
          # login user
          visit login_path
          fill_in 'email', with: user.email
          fill_in 'password', with: '12345678'
          click_button 'Login'
          expect(current_path).to eq root_path
          expect(page).to have_content('Login successful')
        end
        it '新規作成したタスクが表示される' do
          task = create(:task, user: user)
          visit user_path(1)
          expect(current_path).to eq user_path(1)
          expect(page).to have_content(task.title)
          expect(page).to_not have_content('There is no task.')
        end # it '新規作成したタスクが表示される' do
      end #context 'タスクを作成' do
    end  # describe 'マイページ' do
  end # describe 'ログイン後' do
end 
