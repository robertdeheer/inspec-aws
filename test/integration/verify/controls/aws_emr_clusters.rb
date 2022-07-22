aws_emr_cluster_id = input(:aws_emr_cluster_id, value: '', description: 'AWS EMR cluster ID.')
aws_emr_cluster_service_role = input(:aws_emr_cluster_service_role, value: '', description: 'AWS EMR cluster Service Role.')
aws_emr_cluster_service_role.gsub!('"', '') # VARUN: NEED TO REWMOVE IT
aws_emr_cluster_applications = input(:aws_emr_cluster_applications, value: '', description: 'IAM role that will be assumed by the Amazon EMR service to access AWS resources on your behalf.')
aws_emr_cluster_arn = input(:aws_emr_cluster_arn, value: '', description: 'ARN of the cluster.')
aws_emr_cluster_arn.gsub!('"', '')
aws_emr_cluster_name = input(:aws_emr_cluster_name, value: '', description: 'Name of the cluster.')
aws_emr_cluster_name.gsub!('"', '')
aws_emr_cluster_visible_to_all_users = input(:aws_emr_cluster_visible_to_all_users, value: '', description: 'Indicates whether the job flow is visible to all IAM users of the AWS account associated with the job flow.')
aws_emr_cluster_release_label = input(:aws_emr_cluster_release_label, value: '', description: 'Release label for the Amazon EMR release.')
aws_emr_cluster_release_label.gsub!('"', '')

control 'aws-emr-clusters-1.0' do
  impact 1.0
  title 'Test AWS EMR Cluster in bulk'

  describe aws_emr_clusters do
    it { should exist }
    its('cluster_ids') { should include aws_emr_cluster_id}
    its('status_states') { should include 'WAITING'}
    its('service_roles') { should include aws_emr_cluster_service_role }
    its('cluster_arns') { should include aws_emr_cluster_arn }
    its('cluster_names') { should include aws_emr_cluster_name }
    its('release_labels') { should include aws_emr_cluster_release_label }
  end

  describe aws_emr_clusters.where(status_state: 'WAITING') do
    it { should exist }
  end
end
