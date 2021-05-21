control 'aws_redshift_clusters-1.0' do

  impact 1.0
  title 'Ensure AWS redshift clusters has the correct properties.'

  describe aws_redshift_clusters do
    it { should exist }
    its ('node_type') { should include 'dc2.large' }
    its ('cluster_status') { should include 'available'  }
    its ('cluster_availability_status') { should include 'Available' }
    its ('master_username') { should include 'test-cluster' }
    its ('db_name') { should include 'dev' }
    its ('vpc_id') { should include 'vpc-6d9d7505' }
    its ('cluster_availability_status') { should include 'Available' }
    its ('cluster_subnet_group_name') { should include 'default' }
    its ('allow_version_upgrade') { should include true }
    its ('encrypted') { should include false }

  end
end


