# frozen_string_literal: true

require 'aws_backend'

class AwsIamPolicy < AwsResourceBase
  name 'aws_iam_policy'
  desc 'Verifies settings for an Iam Policy'

  example "
    describe aws_iam_policy('policy-1') do
      it { should exist }
    end
  "

  attr_reader :arn, :attachment_count, :default_version_id, :policy_name, :policy_id, :attached_groups,
              :attached_roles, :attached_users

  def initialize(opts = {})
    super(opts)
    validate_parameters([:policy_arn, :policy_name])

    if opts.key?(:policy_arn)
      @resp = get_policy_by_arn(opts[:policy_arn])
    elsif opts.key?(:policy_name)
      @resp = get_policy_by_name(opts[:policy_name])
    end
    get_attached_entities(@resp.arn)

      @arn                = @resp.arn
      @policy_name        = @resp.policy_name
      @policy_id          = @resp.policy_id
      @attachment_count   = @resp.attachment_count
      @default_version_id = @resp.default_version_id
  end

  # Required to maintain compatibility with previous implementation
  def get_policy_by_name(policy_name)
    policy = nil
    catch_aws_errors do
      pagination_opts = { max_items: 1000 }
      loop do
        policies = @aws.iam_client.list_policies(pagination_opts)
        policy = policies.policies.detect do |p|
          p.policy_name == policy_name
        end
        break if policy
        break unless policies.is_truncated
        pagination_opts[:marker] = policies.marker
      end
    end
    policy
  end

  def get_policy_by_arn(arn)
    resp = nil
    catch_aws_errors do
      policy_arn = { policy_arn: arn }
      resp = @aws.iam_client.get_policy(policy_arn).policy
    end
    resp
  end

  def get_attached_entities(arn)
    criteria = {policy_arn: arn}
    resp = nil
    catch_aws_errors do
      resp = @aws.iam_client.list_entities_for_policy(criteria)
    end
    @attached_groups = resp.policy_groups.map(&:group_name)
    @attached_users  = resp.policy_users.map(&:user_name)
    @attached_roles  = resp.policy_roles.map(&:role_name)
  end

  def exists?
    !@arn.nil?
  end

  def to_s
    "AWS Iam Policy #{@policy_name}"
  end
end
