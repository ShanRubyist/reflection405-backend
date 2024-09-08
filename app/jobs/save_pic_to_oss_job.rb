class SavePicToOssJob < ApplicationJob
  queue_as :default

  def perform(args)
    save_to_db(args)
  end

  private

  def save_to_db(h)
    user = h.fetch(:user)
    model_name = h.fetch(:model_name)
    aspect_ratio = h.fetch(:aspect_ratio)
    prompt = h.fetch(:prompt) { nil }
    data = h.fetch(:data) { {} }
    output = data.fetch("output")
    predict_id = data.fetch("id")
    if data.fetch('status') == 'succeeded'
      cost_credits = 20
    else
      cost_credits = 0
    end

    user
      .replicated_calls
      .create(data: data,
              output: output.join,
              prompt: prompt,
              cost_credits: cost_credits,
              model: model_name,
              predict_id: 'predict_id')
  rescue => e
    puts e
  end

end
