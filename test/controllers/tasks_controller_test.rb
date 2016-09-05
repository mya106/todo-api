require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:premier)
  end

  test 'should get index' do
    get tasks_url
    assert_response :success

    json = JSON.parse(@response.body)
    assert_equal 2, json.size
    assert json.any? { |task| task['title'] == 'プレミアリーグ観戦' }
    assert json.any? { |task| task['title'] == 'Jリーグ観戦' }
  end

  test 'should get index with keyword for title' do
    get tasks_url(keyword: 'プレミアリーグ観戦')
    assert_response :success

    json = JSON.parse(@response.body)
    assert json.all? { |task| task['title'].include?('プレミアリーグ観戦') }
  end

  test 'should get index with keyword for description' do
    get tasks_url(keyword: 'TVで観戦する')
    assert_response :success

    json = JSON.parse(@response.body)
    assert json.all? { |task| task['description'].include?('TVで観戦する') }
  end

  test 'should create task' do
    assert_difference('Task.count') do
      post tasks_url, params: { task: { description: 'ブンデスリーガをTVで観戦する', title: 'ブンデスリーガ観戦' } }
    end

    assert_response 201

    json = JSON.parse(@response.body)
    assert_equal 'ブンデスリーガ観戦', json['title']
    assert_equal 'ブンデスリーガをTVで観戦する', json['description']
    assert_equal task_url(id: json['id']), json['url']
  end

  test 'should show task' do
    get task_url(@task)
    assert_response :success

    json = JSON.parse(@response.body)
    assert_equal @task.title, json['title']
    assert_equal @task.description, json['description']
    assert_equal task_url(@task), json['url']
  end

  test 'should update task' do
    patch task_url(@task), params: { task: { description: 'プレミアリーグをスタジアムで観戦する', title: 'プレミアリーグ生観戦' } }
    assert_response 200

    json = JSON.parse(@response.body)
    assert_equal 'プレミアリーグ生観戦', json['title']
    assert_equal 'プレミアリーグをスタジアムで観戦する', json['description']
    assert_equal task_url(@task), json['url']
  end

  test 'should destroy task' do
    assert_difference('Task.count', -1) do
      delete task_url(@task)
    end

    assert_response 204
  end
end
