# frozen_string_literal: true

require "cell/partial"

module Decidim
  module Proposals
    # This cell renders a proposal with its M-size card.
    class ProposalMCell < Decidim::CardMCell
      include ProposalCellsHelper


      def badge
        render if has_badge?
      end

      private

      def title
        decidim_html_escape(present(model).title)
      end

      def body
        present(model).body
      end

      def has_state?
        model.published?
      end

      def has_badge?
        published_state? || withdrawn?
      end

      def has_link_to_resource?
        model.published?
      end

      def has_footer?
        return false if model.emendation?

        true
      end

      def description
        strip_tags(body).truncate(100, separator: /\s/)
      end

      def badge_classes
        return super unless options[:full_badge]

        state_classes.concat(["label", "proposal-status"]).join(" ")
      end

      def statuses
        # ここでDBを呼ぶのはだいぶよくないけど仕方ない...
        # いいねを無効にしたときはメトリクスからいいねを除外
        component = Decidim::Component.find(model.decidim_component_id)
        return [:endorsements_count, :comments_count] if model.draft?
        return [:creation_date, :endorsements_count, :comments_count] if !has_link_to_resource? || !can_be_followed?

        bar_content = [:creation_date]
        if ! component.current_settings.endorsements_blocked?
          bar_content.push(:endorsements_count)
        end

        if ! component.current_settings.comments_blocked?
          bar_content.push(:comments_count)
        end
        bar_content#ここを変更
      end

      def creation_date_status
        l(model.published_at.to_date, format: :decidim_short)
      end

      def endorsements_count_status
        return endorsements_count unless has_link_to_resource?

        link_to resource_path do
          endorsements_count
        end
      end

      def comments_count_status
        return comments_count unless has_link_to_resource?
  
        link_to resource_path do
          comments_count
        end
      end

      def endorsements_count
        with_tooltip t("decidim.proposals.models.proposal.fields.endorsements") do
          #icon("bullhorn", class: "icon--small") + " " + model.proposal_endorsements_count.to_s + ' ' +  t("decidim.proposals.models.proposal.fields.endorsements")
          icon("bullhorn", class: "icon--small") + " " + model.proposal_endorsements_count.to_s + ' ' +  t("decidim.proposals.proposals.endorsements_count")
        end
      end

      def comments_count
        with_tooltip t("decidim.comments.comments") do
          #icon("comment-square", class: "icon--small") + " " + model.comments.count.to_s + ' ' +  t("decidim.proposals.models.proposal.fields.comments")
          icon("comment-square", class: "icon--small") + " " + model.comments.count.to_s + ' ' +  t("decidim.proposals.proposals.comments_count")
        end
      end

      def progress_bar_progress
        model.proposal_votes_count || 0
      end

      def progress_bar_total
        model.maximum_votes || 0
      end

      def progress_bar_subtitle_text
        if progress_bar_progress >= progress_bar_total
          t("decidim.proposals.proposals.votes_count.most_popular_proposal")
        else
          t("decidim.proposals.proposals.votes_count.need_more_votes")
        end
      end

      def can_be_followed?
        !model.withdrawn?
      end

      def has_image?
        model.attachments.first.present? && model.attachments.first.file.content_type.start_with?("image") && model.component.settings.allow_card_image
      end

      def resource_image_path
        model.attachments.first.url if has_image?
      end
    end
  end
end