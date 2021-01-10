package z.y.x.aws;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.nodes.Tag;



import z.y.x.aws.ec2.AWSEC2GroupWrapper;
import z.y.x.aws.ec2.AwsEc2Pojo;
import z.y.x.aws.ec2.secgroup.AWSSecurityGroupPojo;
import z.y.x.aws.ec2.secgroup.AWSSecurityGroupWrapper;
import z.y.x.aws.ec2.secgroup.Ec2Group;
import z.y.x.aws.ec2.secgroup.Rule;
import z.y.x.aws.ec2.secgroup.RulesEgress;
import z.y.x.aws.ec2.secgroup.Task;

public class Utils {
	
	public static Yaml getYAML()
	{
		
		DumperOptions options = new DumperOptions();
		options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
		
		ConfigurationModelRepresenter customRepresenter = new ConfigurationModelRepresenter();
		customRepresenter.addClassTag(Rule.class, Tag.MAP);
		customRepresenter.addClassTag(Ec2Group.class, Tag.MAP);
		customRepresenter.addClassTag(RulesEgress.class, Tag.MAP);
		customRepresenter.addClassTag(AWSSecurityGroupWrapper.class, Tag.MAP);
		customRepresenter.addClassTag(AWSSecurityGroupPojo.class, Tag.MAP);
		customRepresenter.addClassTag(AWSEC2GroupWrapper.class, Tag.MAP);
		customRepresenter.addClassTag(AwsEc2Pojo.class, Tag.MAP);
		customRepresenter.addClassTag(z.y.x.aws.route53.AWSRoute53Wrapper.class, Tag.MAP);
		customRepresenter.addClassTag(z.y.x.aws.route53.Route53.class, Tag.MAP);
		customRepresenter.addClassTag(z.y.x.aws.route53.Task.class, Tag.MAP);
		customRepresenter.addClassTag(Task.class, Tag.MAP);
		customRepresenter.addClassTag(z.y.x.aws.ec2.Task.class, Tag.MAP);
		customRepresenter.getPropertyUtils().setSkipMissingProperties(true);
		
		//Add VPC
		customRepresenter.addClassTag(z.y.x.aws.vpc.AmazonAwsEc2VpcNet.class, Tag.MAP);
		customRepresenter.addClassTag(z.y.x.aws.vpc.AWSVPCWrapper.class, Tag.MAP);
		customRepresenter.addClassTag(z.y.x.aws.vpc.Task.class, Tag.MAP);
		
		Yaml yaml = new Yaml(customRepresenter, options);
		
		return yaml;
		
	}

}
