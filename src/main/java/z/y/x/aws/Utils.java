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
		customRepresenter.getPropertyUtils().setSkipMissingProperties(true);
		
		Yaml yaml = new Yaml(customRepresenter, options);
		
		return yaml;
		
	}

}
