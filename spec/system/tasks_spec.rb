require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe '正常系' do
    context 'ログインした状態でタスクの新規作成、編集、削除ができること' do
      let(:user)  { create(:user) }
      before do
        # login user
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: '12345678'
        click_button 'Login'
        expect(current_path).to eq root_path
        expect(page).to have_content('Login successful')
      end
      it 'タスクの新規作成' do 
        visit tasks_path
        click_link 'New Task'
        expect { 
          fill_in 'task_title', with: 'AAAA'
          fill_in 'task_content', with: 'BBBB'
          select 'doing'
          # fill_in 'task_deadline', with: "12272021\t011200"
          click_button 'Create Task'
        }.to change {Task.count}.by(1) 
        expect(page).to have_content('Task was successfully created.')
        expect(page).to have_content('AAAA')
        expect(page).to have_content('BBBB')
        expect(page).to have_content('doing')
        # expect(page).to have_content('2021/12/27 1:12')        
      end
  
      it '新規作成したタスクが一覧に表示される' do
        task = create(:task, user: user)
        visit tasks_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content(task.title)
        expect(page).to_not have_content('There is no task.')

        expect(page).to have_content(task.title)
        expect(page).to have_content(task.content)
        expect(page).to have_content(task.status)

      end # it '新規作成したタスクが表示される' do
  
      it '照会&編集' do
        task = create(:task, user: user)
        visit task_path(task.id)
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.content)
        expect(page).to have_content(task.status)
        
        click_link 'Edit'
        expect(current_path).to eq edit_task_path(task)

        expect { 
          fill_in 'task_title', with: 'XXX'
          fill_in 'task_content', with: 'YYY'
          select 'done'
          # fill_in 'task_deadline', with: "12272022\t123400"
          click_button 'Update Task'
        }.to change {Task.count}.by(0) 
        expect(page).to have_content('Task was successfully updated.')
        expect(page).to have_content('XXX')
        expect(page).to have_content('YYY')
        expect(page).to have_content('done')
        # expect(page).to have_content('2022/12/27 12:34')
      end
      it '削除' do 
        expect {
          task = create(:task, user: user)
          visit tasks_path
          page.accept_confirm do
            click_link "task-#{task.id}-destroy"
          end
        }.to change{Task.count}.by(1)
        expect(page).to have_content('Task was successfully destroyed.')
      end            
    end  
  end

  describe '異常系' do
    context 'ログインしていないユーザーでタスクの新規作成、編集、マイページへの遷移ができないこと' do
      let(:user)  { create(:user) }
      let(:task) { create(:task) }
      it 'タスクの新規作成' do 
        visit tasks_path
        expect(page).to_not have_content('New Task')
      end
      it '照会&編集' do
        visit tasks_path
        expect(page).to_not have_content('Edit')

        visit task_path(task.id)
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.content)
        expect(page).to have_content(task.status)
        
        click_link 'Edit'
        expect(current_path).to eq login_path
        expect(page).to have_content('Login required')
      end
      it '削除' do 
        visit tasks_path
        expect(page).to_not have_content('Destroy')
      end         
    end
  
    context '他のユーザーのタスク編集／削除ページへの遷移ができないこと' do
      let(:user)  { create(:user) }
      let(:task) { create(:task) }
      it '照会&編集' do
        visit tasks_path
        expect(page).to_not have_link("task-#{task.id}-edit")

        visit task_path(task.id)
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.content)
        expect(page).to have_content(task.status)
        
        click_link 'Edit'
        expect(current_path).to eq login_path
      end
      it '削除' do 
        visit tasks_path
        expect(page).to_not have_link("task-#{task.id}-destroy")
      end          
    end
  end
end