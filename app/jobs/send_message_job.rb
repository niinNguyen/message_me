class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    mine = differ('mine', message)
    theirs = differ('theirs', message)

    ActionCable.server.broadcast "room_channel_#{message.room_id}", { mine: mine, theirs: theirs, message: message }

    # if Rails.configuration.active_job.queue_adapter == :async
    #   executor =
    #     ActiveJob::Base._queue_adapter.instance_eval do
    #       @scheduler.instance_eval { @async_executor }
    #     end
    #   sleep(0.1) while executor.scheduled_task_count > executor.completed_task_count
    # end
  end

  def differ(title, message)
    ApplicationController.render(
      partial: "messages/#{title}",
      locals: { message: message }
    )
  end
end
