package billing

import "context"

func (NoopStore) GetAIQuota(_ context.Context, user UserIdentity) (AIQuotaStatus, error) {
	return unlimitedQuotaStatus(user), nil
}

func (NoopStore) CheckAIQuota(context.Context, UserIdentity) error {
	return nil
}

func (NoopStore) AddAIUsage(context.Context, UserIdentity, int64) error {
	return nil
}

func (NoopStore) TierModelID(context.Context, UserIdentity) (string, error) {
	return "", nil
}
